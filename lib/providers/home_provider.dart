import 'dart:convert';

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

  final MarginsNotifier marginsNotifier;
  final ProfileChangeNotifier profileChangeNotifier;

  ///
  HomeState state = HomeInitial();

  double usdToInrFactor = 79;

  /// Websocket to listen : wss://stream.wazirx.com/stream
  IOWebSocketChannel? wazirXChannel;

  /// Fetches crypto data from wazirx, kraken
  ///
  /// Also starts a websocket listener for wazirX api
  Future<void> getCryptoDataFromAPIs() async {
    _emit(state.copyWith(loadStatus: LoadStatus.loading));
    // await fetchExchangeRate();

    await fetchCurrencyDataFromWazirX();
    await fetchCurrencyDataFromKraken();

    if (state.cryptoCurrencies.isNotEmpty) {
      _calculateDifference();
    }

    wazirXChannel?.sink.close();
    startWazirXCryptoTicker();
    _emit(state.copyWith(loadStatus: LoadStatus.done));
  }

  /// [currency] corresponds to either "inr" or "usd"
  static List<String> cryptoKeys() => [
        'btc',
        'sol',
        'eth',
        'matic',
        'usdt',
        'shib',
      ];

  /// Listens and updates for changes from 'wss://stream.wazirx.com/stream'
  ///
  ///
  void startWazirXCryptoTicker() async {
    wazirXChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://stream.wazirx.com/stream'),
    );

    wazirXChannel?.stream.asBroadcastStream().listen((event) async {
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
      }
      fetchCurrencyDataFromKraken();
      marginsNotifier.getAllMargins();
    });
  }

  ///
  Future<void> logout(BuildContext context) async {
    _emit(HomeInitial());
    await Provider.of<ProfileChangeNotifier>(context, listen: false).reset();
    (await SharedPreferences.getInstance()).clear();
    await FirebaseAuth.instance.signOut();
  }

  /// Change the current selected cryptocurrency
  Future<void> changeCryptoKey(String key) async {
    var cryptoKeys = HomeStateNotifier.cryptoKeys();
    assert(cryptoKeys.contains(key));
    _emit(
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
          _parseCurrenciesFromWazirCryptoData(mapResponse);
      if (state is HomeData) {
        _emit((state as HomeData).copyWith(cryptoCurrencies: currencies));
      } else {
        _emit(
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
  ///
  /// TODO: change this to XE.com apo
  Future<void> fetchExchangeRate() async {
    final response = await get(
      Uri.parse(
        "https://openexchangerates.org/api/latest.json?app_id=9a521d92799d41be86ea3f8a571567a4",
      ),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      usdToInrFactor = responseBody["rates"]["INR"];

      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }
  }

  ///
  Future<void> fetchCurrencyDataFromKraken() async {
    //fetchExchangeRate();

    String wazirXKey = state.selectedCurrencyKey;
    String krakenKey = '${wazirXKey.toUpperCase()}USD';
    final response = await get(
      Uri.parse(
        "https://api.kraken.com/0/public/Ticker?pair=$krakenKey",
      ),
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var resultKey = body['result'].keys.first;
      var data = body['result'][resultKey];
      var first2 = data["c"].first;

      double krakenPrice = double.parse(first2);
      krakenPrice =
          krakenPrice - (krakenPrice * marginsNotifier.totalMargin / 100);
      if (!state.isUSD) {
        var usdConvert = _doConversionToINR(krakenPrice);
        krakenPrice = usdConvert;
      }
      var currencies = state.cryptoCurrencies.toList();
      currencies = _updateCurrenciesWithKrakenData(
        currencies,
        state.selectedCurrencyKey,
        krakenPrice,
      );
      _emit(state.copyWith(cryptoCurrencies: currencies));
    }
  }

  /// Returns the current cryptocurrency selected by the user
  CryptoCurrency currentCryptoCurrency() {
    assert(state.cryptoCurrencies.isNotEmpty);

    return state.cryptoCurrencies.firstWhere(
      (element) => element.key == state.selectedCurrencyKey,
    );
  }

  /// Changes USD to INR, or vice-versa
  Future<void> toggleIsUSD(bool isUsd) async {
    _emit(
      state.copyWith(
        isUSD: isUsd,
      ),
    );
    assert(state.isUSD == isUsd);
    var cryptoCurrencies = state.cryptoCurrencies.toList();
    int index = cryptoCurrencies
        .indexWhere((element) => element.key == state.selectedCurrencyKey);
    if (index != -1) {
      var crypto = state.cryptoCurrencies[index];
      // ignore: prefer-conditional-expressions
      if (isUsd) {
        crypto = crypto.copyWith(
          wazirxBuyPrice: crypto.wazirxBuyPrice / usdToInrFactor,
          krakenPrice: crypto.krakenPrice / usdToInrFactor,
        );
      } else {
        crypto = crypto.copyWith(
          wazirxBuyPrice: crypto.wazirxBuyPrice * usdToInrFactor,
          krakenPrice: crypto.krakenPrice * usdToInrFactor,
        );
      }
      cryptoCurrencies[index] = crypto;
      _emit(state.copyWith(cryptoCurrencies: cryptoCurrencies));
    }
  }

  /// Changes state and notifies listeners
  void _emit(HomeState newState) {
    state = newState;
    notifyListeners();
  }

  void _parseAndEmitWazirXTickerData(cryptoData) {
    for (var crypto in cryptoData.toList()) {
      var key = crypto['s'];
      if (cryptoKeys().contains(key.toString().replaceAll('inr', ''))) {
        var buyPrice = crypto['c'];

        final cryptoCurrencies = state.cryptoCurrencies.toList();
        int index = cryptoCurrencies.indexWhere(
          (element) => element.key == key.toString().replaceAll('inr', ''),
        );
        if (index != -1) {
          var totalPrice = double.parse(buyPrice) +
              (double.parse(buyPrice) * marginsNotifier.totalMargin / 100);
          if (state.isUSD) {
            totalPrice = totalPrice / usdToInrFactor;
          }
          cryptoCurrencies[index] = cryptoCurrencies[index].copyWith(
            wazirxBuyPrice: totalPrice,
          );

          _emit(state.copyWith(cryptoCurrencies: cryptoCurrencies));
          notifyListeners();
        }
      }
    }
  }

  double _doConversionToINR(double dollars) {
    return dollars * usdToInrFactor;
  }

  List<CryptoCurrency> _updateCurrenciesWithKrakenData(
    List<CryptoCurrency> currencies,
    String key,
    double krakenPrice,
  ) {
    var indexWhere = currencies.indexWhere((currency) => currency.key == key);
    if (indexWhere != -1) {
      currencies[indexWhere] = currencies[indexWhere].copyWith(
        key: key,
        krakenPrice: krakenPrice,
      );
    }

    return currencies;
  }

  List<CryptoCurrency> _parseCurrenciesFromWazirCryptoData(
    Map<String, dynamic> mapResponse,
  ) {
    List<CryptoCurrency> currencies = state.cryptoCurrencies;
    for (var key in cryptoKeys()) {
      if (mapResponse.containsKey('${key}inr')) {
        var cryptoData = mapResponse['${key}inr'];
        var indexWhere =
            currencies.indexWhere((currency) => currency.key == key);
        var buyPrice = double.parse(cryptoData['last']);
        var totalBuyPrice =
            buyPrice + (buyPrice * marginsNotifier.totalMargin / 100);
        if (state.isUSD) {
          totalBuyPrice = totalBuyPrice / usdToInrFactor;
        }
        if (indexWhere != -1) {
          currencies[indexWhere] = currencies[indexWhere].copyWith(
            key: key,
            wazirxBuyPrice: totalBuyPrice,
          );
        } else {
          currencies.add(
            CryptoCurrency(
              key: key,
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
    _emit(
      state.copyWith(
        difference: 100 *
            ((crypto.wazirxBuyPrice - crypto.krakenPrice) / crypto.krakenPrice),
      ),
    );
  }
}
// 100 * ((crypto.wazirxPrice – crypto.krakenPrice) / crypto.krakenPrice)
// 100 * ((2533118-2415313.58)/2415313.58)
