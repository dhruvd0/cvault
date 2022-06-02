import 'dart:convert';

import 'package:cvault/models/home_state.dart';
import 'package:cvault/Screens/home/models/crypto_currency.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/material.dart';
import 'package:money_converter/Currency.dart';
import 'package:money_converter/money_converter.dart';

class HomeStateNotifier extends ChangeNotifier {
  HomeStateNotifier() : super() {
    if (Firebase.apps.isNotEmpty) {
      FirebaseAuth.instance
          .authStateChanges()
          .asBroadcastStream()
          .listen((event) {
        if (event != null) {
          getCryptoDataFromAPIs();
        }
      });
    }
  }

  Future<void> getCryptoDataFromAPIs() async {
    emit(state.copyWith(loadStatus: LoadStatus.loading));

    await fetchCurrencyDataFromWazirX();
    await fetchCurrencyDataFromKraken();

    emit(state.copyWith(loadStatus: LoadStatus.done));
    _calculateDifference();
    wazirXChannel?.sink.close();
    startWazirXCryptoTicker();
  }

  /// [currency] corresponsds to either "inr" or "usdt"
  static List<String> cryptoKeys(String currency) => [
        'btc',
        'sol',
        'eth',
        'matic',
        'ada',
        'shib',
      ].map((e) => e + currency).toList();

  HomeState state = HomeInitial();
  IOWebSocketChannel? wazirXChannel;

  /// Changes state and notifies listeners
  void emit(HomeState newState) {
    state = newState;
    notifyListeners();
  }

  void startWazirXCryptoTicker() {
    wazirXChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://stream.wazirx.com/stream'),
    );

    wazirXChannel?.stream.asBroadcastStream().listen((event) {
      if (event != null && event.contains('connected')) {
        wazirXChannel?.sink.add(jsonEncode({
          "event": "subscribe",
          "streams": ["!ticker@arr"],
        }));
      } else {
        Map<String, dynamic> baseData = jsonDecode(event);
        if (baseData.containsKey('data') && baseData['data'] is List) {
          var cryptoData = baseData['data'];
          for (var crypto in cryptoData.toList()) {
            var key = crypto['s'];
            if (cryptoKeys(state.isUSD ? 'usdt' : 'inr').contains(key)) {
              var price = crypto['b'];
              final cryptoCurrencies = state.cryptoCurrencies.toList();
              int index = cryptoCurrencies
                  .indexWhere((element) => element.wazirxKey == key);
              if (index != -1) {
                cryptoCurrencies[index] = cryptoCurrencies[index]
                    .copyWith(wazirxPrice: double.parse(price));
                emit(state.copyWith(cryptoCurrencies: cryptoCurrencies));
              }
            }
          }
        }
      }
    });
  }

  Future<void> logout(BuildContext context) async {
    emit(HomeInitial());
    Provider.of<ProfileChangeNotifier>(context, listen: false).reset();
    (await SharedPreferences.getInstance()).clear();
    await FirebaseAuth.instance.signOut();
  }

  void changeCryptoKey(String key) {
    assert(HomeStateNotifier.cryptoKeys(state.isUSD ? 'usdt' : 'inr')
        .contains(key));
    emit(state.copyWith(selectedCurrencyKey: key));
    getCryptoDataFromAPIs();
  }

  Future<void> fetchCurrencyDataFromWazirX() async {
    emit(state.copyWith(cryptoCurrencies: []));
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
            selectedCurrencyKey: cryptoKeys(state.isUSD ? 'usdt' : 'inr').first,
            isUSD: state.isUSD,
          ),
        );
      }
    }
  }

//kraken
  /// Maps crypto name of wazirx api to kraken api
  Map<String, String> keyPairFromWazirxToKraken = {
    'btcinr': 'TBTCUSD',
    'btcusdt': 'TBTCUSD',
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

  Future<void> fetchCurrencyDataFromKraken() async {
    String wazirXKey = state.selectedCurrencyKey;
    String krakenKey = keyPairFromWazirxToKraken[wazirXKey]!;
    final response = await get(Uri.parse(
      "https://api.kraken.com/0/public/Ticker?pair=$krakenKey",
    ));
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
    /// TODO: usd to inr conversion
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
    } else {
      currencies.add(CryptoCurrency(
        wazirxKey: wazirXKey,
        krakenKey: krakenKey,
        name: '',
        wazirxPrice: 0.0,
        krakenPrice: krakenPrice,
      ));
    }

    return currencies;
  }

  CryptoCurrency currentCryptoCurrency() {
    assert(state.cryptoCurrencies.isNotEmpty);
    return state.cryptoCurrencies.firstWhere(
        (element) => element.wazirxKey == state.selectedCurrencyKey);
  }

//kraken
  Future<void> toggleUSDToINR(bool value) async {
    emit(state.copyWith(isUSD: value));

    assert(state.isUSD == value);
    await getCryptoDataFromAPIs();
    emit(state.copyWith(isUSD: value));
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
        if (indexWhere != -1) {
          currencies[indexWhere] = currencies[indexWhere].copyWith(
            wazirxKey: key,
            wazirxPrice: double.parse(cryptoData['buy']),
          );
        } else {
          currencies.add(CryptoCurrency(
            wazirxKey: key,
            krakenKey: keyPairFromWazirxToKraken[key]!,
            name: cryptoData['name'],
            wazirxPrice: double.parse(cryptoData['buy']),
            krakenPrice: 0.0,
          ));
        }
      }
    }

    return currencies;
  }

  void _calculateDifference() {
    var crypto = currentCryptoCurrency();
    emit(state.copyWith(difference: crypto.krakenPrice - crypto.wazirxPrice));
  }
}
