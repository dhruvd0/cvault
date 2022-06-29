import 'dart:convert';
import 'dart:developer';

import 'package:cvault/models/home_state.dart';
import 'package:cvault/Screens/home/models/crypto_currency.dart';
import 'package:cvault/providers/margin_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';

/// Handles state for [DashboardPage]
class HomeStateNotifier extends ChangeNotifier {
  ///
  HomeStateNotifier({
    required this.marginsNotifier,
    FirebaseAuth? firebaseAuthMock,
    required this.profileChangeNotifier,
  }) : super() {
    final authInstance = firebaseAuthMock ?? FirebaseAuth.instance;

    authInstance.authStateChanges().asBroadcastStream().listen((event) {
      if (event != null) {
        getCryptoDataFromAPIs();
      }
    });
  }
 
  final ProfileChangeNotifier profileChangeNotifier;

  final MarginsNotifier marginsNotifier;

  /// Fetches crypto data from wazirx, kraken
  ///
  /// Also starts a websocket listener for wazirX api
  Future<void> getCryptoDataFromAPIs() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));

    await fetchCurrencyDataFromWazirX();
    await fetchCurrencyDataFromKraken();

    emit(state.copyWith(loadStatus: LoadStatus.done));
    _calculateDifference();
    wazirXChannel?.sink.close();
    startWazirXCryptoTicker();
    await marginsNotifier.getAllMargins();
  }

  /// [currency] corresponds to either "inr" or "usdt"
  static List<String> cryptoKeys(String currency) => [
        'btc',
        'sol',
        'eth',
        'matic',
        'ada',
        'shib',
      ].map((e) => e + currency).toList();

  ///
  HomeState state = HomeInitial();

  /// Websocket to listen : wss://stream.wazirx.com/stream
  IOWebSocketChannel? wazirXChannel;

  /// Changes state and notifies listeners
  void emit(HomeState newState) {
    state = newState;
    notifyListeners();
  }

  /// Listens and updates for changes from 'wss://stream.wazirx.com/stream'
  ///
  ///
  void startWazirXCryptoTicker() {
    wazirXChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://stream.wazirx.com/stream'),
    );

    wazirXChannel?.stream.asBroadcastStream().listen((event) {
      if (event != null && event.contains('connected')) {
        wazirXChannel?.sink.add(
          jsonEncode({
            "event": "subscribe",
            "streams": ["!ticker@arr"],
          }),
        );
      } else {
        Map<String, dynamic> baseData = jsonDecode(event);
        if (baseData.containsKey('data') && baseData['data'] is List) {
          var cryptoData = baseData['data'];
          _parseAndEmitWazirXTickerData(cryptoData);
        }
        fetchCurrencyDataFromKraken();
      }
    });
  }

  void _parseAndEmitWazirXTickerData(cryptoData) {
    for (var crypto in cryptoData.toList()) {
      var key = crypto['s'];
      if (cryptoKeys(state.isUSD ? 'usdt' : 'inr').contains(key)) {
        var buyPrice = crypto['a'];
        final cryptoCurrencies = state.cryptoCurrencies.toList();
        int index =
            cryptoCurrencies.indexWhere((element) => element.wazirxKey == key);
        if (index != -1) {
          cryptoCurrencies[index] = cryptoCurrencies[index].copyWith(
            wazirxBuyPrice: double.parse(buyPrice) +
                (double.parse(buyPrice) * marginsNotifier.totalMargin / 100),
          );
          emit(state.copyWith(cryptoCurrencies: cryptoCurrencies));
          notifyListeners();
        }
      }
    }
  }

  ///
  Future<void> logout(BuildContext context) async {
    emit(HomeInitial());
    await Provider.of<ProfileChangeNotifier>(context, listen: false).reset();
    (await SharedPreferences.getInstance()).clear();
    await FirebaseAuth.instance.signOut();
  }

  /// Change the current selected cryptocurrency
  Future<void> changeCryptoKey(String key) async {
    var cryptoKeys = HomeStateNotifier.cryptoKeys(state.isUSD ? 'usdt' : 'inr');
    assert(cryptoKeys.contains(key));
    emit(
      state.copyWith(
        selectedCurrencyKey: key,
        loadStatus: LoadStatus.loading,
      ),
    );

    await getCryptoDataFromAPIs();
  }

  /// Fetches and updates cryptocurrencies from api.wazirx
  Future<void> fetchCurrencyDataFromWazirX() async {
    final Response response =
        await get(Uri.parse("https://api.wazirx.com/api/v2/tickers"));

    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = jsonDecode(response.body);
      List<CryptoCurrency> currencies =
          _parseCurrenciesFromCryptoData(mapResponse);
      if (state is HomeData) {
        emit((state as HomeData).copyWith(cryptoCurrencies: currencies));
      } else {
        emit(
          HomeData(
            cryptoCurrencies: currencies,
            selectedCurrencyKey: state.selectedCurrencyKey,
            isUSD: state.isUSD,
            loadStatus: state.loadStatus,
          ),
        );
      }
    }
  }

  /// Gets the usd to inr exchange rate, for example: 77.01
  Future<double> fetchExchangeRate() async {
    final response = await get(
      Uri.parse(
        "https://openexchangerates.org/api/latest.json?app_id=9a521d92799d41be86ea3f8a571567a4",
      ),
    );
    late double usdToInrRate;
    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      usdToInrRate = responseBody["rates"]["INR"];
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }

    return usdToInrRate;
  }

//kraken
  /// Maps crypto name of wazirx api to kraken api
  Map<String, String> keyPairFromWazirxToKraken = {
    'btcinr': 'BTCUSD',
    'btcusdt': 'BTCUSD',
    'solinr': 'SOLUSD',
    'solusdt': 'SOLUSD',
    'ethinr': 'ETHUSD',
    'ethusdt': 'ETHUSD',
    'maticinr': 'MATICUSD',
    'maticusdt': 'MATICUSD',
    'adainr': 'ADAUSD',
    'adausdt': 'ADAUSD',
    'shibinr': 'SHIBUSD',
    'shibusdt': 'SHIBUSD',
  };

  ///
  Future<void> fetchCurrencyDataFromKraken() async {
    String wazirXKey = state.selectedCurrencyKey;
    String krakenKey = keyPairFromWazirxToKraken[wazirXKey]!;
    final response = await get(
      Uri.parse(
        "https://api.kraken.com/0/public/Ticker?pair=$krakenKey",
      ),
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var resultKey = body['result'].keys.first;
      var data = body['result'][resultKey];
      var first2 = data["a"].first;
      double krakenPrice = double.parse(first2);

      if (!state.isUSD) {
        var usdConvert = await _doConversionToINR(krakenPrice);
        krakenPrice = usdConvert;
      }
      var currencies = state.cryptoCurrencies.toList();
      currencies = _updateCurrenciesWithKrakenData(
        currencies,
        wazirXKey,
        krakenKey,
        krakenPrice,
      );
      emit(state.copyWith(cryptoCurrencies: currencies));
    }
  }

  Future<double> _doConversionToINR(double dollars) async {
    return dollars * 77.5;
  }

  List<CryptoCurrency> _updateCurrenciesWithKrakenData(
    List<CryptoCurrency> currencies,
    String wazirXKey,
    String krakenKey,
    double krakenPrice,
  ) {
    var indexWhere =
        currencies.indexWhere((currency) => currency.wazirxKey == wazirXKey);
    if (indexWhere != -1) {
      currencies[indexWhere] = currencies[indexWhere].copyWith(
        krakenKey: krakenKey,
        wazirxKey: wazirXKey,
        krakenPrice: krakenPrice,
      );
    }

    return currencies;
  }

  /// Returns the current cryptocurrency selected by the user
  CryptoCurrency currentCryptoCurrency() {
    assert(state.cryptoCurrencies.isNotEmpty);

    return state.cryptoCurrencies.firstWhere(
      (element) => element.wazirxKey == state.selectedCurrencyKey,
    );
  }

  /// Changes USD to INR, or vice-versa
  Future<void> toggleIsUSD(bool isUsd) async {
    emit(state.copyWith(isUSD: isUsd, loadStatus: LoadStatus.loading));

    assert(state.isUSD == isUsd);
    String newKey = state.isUSD
        ? state.selectedCurrencyKey.replaceAll('inr', 'usdt')
        : state.selectedCurrencyKey.replaceAll('usdt', 'inr');
    await changeCryptoKey(newKey);

    emit(state.copyWith(loadStatus: LoadStatus.done));
  }

  List<CryptoCurrency> _parseCurrenciesFromCryptoData(
    Map<String, dynamic> mapResponse,
  ) {
    List<CryptoCurrency> currencies = state.cryptoCurrencies;
    for (var key in cryptoKeys(state.isUSD ? 'usdt' : 'inr')) {
      if (mapResponse.containsKey(key)) {
        var cryptoData = mapResponse[key];
        var indexWhere =
            currencies.indexWhere((currency) => currency.wazirxKey == key);
        var totalBuyPrice = double.parse(cryptoData['buy']) +
            (double.parse(cryptoData['buy']) * marginsNotifier.totalMargin / 100);
        if (indexWhere != -1) {
          currencies[indexWhere] = currencies[indexWhere].copyWith(
            wazirxKey: key,
            wazirxBuyPrice: totalBuyPrice,
          );
        } else {
          currencies.add(
            CryptoCurrency(
              wazirxKey: key,
              krakenKey: keyPairFromWazirxToKraken[key]!,
              name: cryptoData['name'],
              wazirxBuyPrice: totalBuyPrice,
              krakenPrice: 0.0,
            ),
          );
        }
      }
    }

    return currencies;
  }

  void _calculateDifference() {
    var crypto = currentCryptoCurrency();
    emit(
      state.copyWith(
        difference: 100 *
            ((crypto.wazirxBuyPrice - crypto.krakenPrice) / crypto.krakenPrice),
      ),
    );
  }
}
// 100 * ((crypto.wazirxPrice – crypto.krakenPrice) / crypto.krakenPrice)
// 100 * ((2533118-2415313.58)/2415313.58)
