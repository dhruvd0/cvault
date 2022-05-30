import 'dart:convert';

import 'package:cvault/Screens/home/bloc/cubit/home_state.dart';
import 'package:cvault/Screens/home/models/crypto_currency.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

class HomeStateNotifier extends ChangeNotifier {
  HomeStateNotifier() : super() {
    if (Firebase.apps.isNotEmpty) {
      FirebaseAuth.instance
          .authStateChanges()
          .asBroadcastStream()
          .listen((event) {
        if (event != null) {
          fetchCurrencyDataFromWazirX();
          startWazirXCryptoTicker();
        }
      });
    }
  }

  static List<String> cryptoKeys = [
    'btcinr',
    'solinr',
    'ethinr',
    'maticinr',
    'adainr',
    'shibinr',
  ];

  HomeState state = HomeInitial();
  final wazirXChannel = IOWebSocketChannel.connect(
    Uri.parse('wss://stream.wazirx.com/stream'),
  );

  /// Changes state and notifies listeners
  void emit(HomeState newState) {
    state = newState;
    notifyListeners();
  }

  void startWazirXCryptoTicker() {
    wazirXChannel.stream.listen((event) {
      if (event != null && event.contains('connected')) {
        wazirXChannel.sink.add(jsonEncode({
          "event": "subscribe",
          "streams": ["!ticker@arr"],
        }));
      } else {
        Map<String, dynamic> baseData = jsonDecode(event);
        if (baseData.containsKey('data') && baseData['data'] is List) {
          var cryptoData = baseData['data'];
          for (var crypto in cryptoData.toList()) {
            var key = crypto['s'];
            if (cryptoKeys.contains(key)) {
              var price = crypto['b'];
              final cryptoCurrencies = state.cryptoCurrencies.toList();
              int index =
                  cryptoCurrencies.indexWhere((element) => element.key == key);
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
    Provider.of<ProfileNotifier>(context, listen: false).reset();
    (await SharedPreferences.getInstance()).clear();
    await FirebaseAuth.instance.signOut();
  }

  void changeCryptoKey(String key) {
    assert(HomeStateNotifier.cryptoKeys.contains(key));
    emit(state.copyWith(selectedCurrencyKey: key));
  }

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
            selectedCurrencyKey: cryptoKeys.first,
            isUSD: false,
          ),
        );
      }
    }
  }

  void toggleUSDToINR(bool value) {
    emit(state.copyWith(isUSD: value));
    assert(state.isUSD == value);
  }

  List<CryptoCurrency> _parseCurrenciesFromCryptoData(
    Map<String, dynamic> mapResponse,
  ) {
    List<CryptoCurrency> currencies = state.cryptoCurrencies;
    for (var key in cryptoKeys) {
      if (mapResponse.containsKey(key)) {
        var cryptoData = mapResponse[key];
        var indexWhere =
            currencies.indexWhere((currency) => currency.key == key);
        if (indexWhere != -1) {
          currencies[indexWhere] = currencies[indexWhere].copyWith(
            key: key,
            wazirxPrice: double.parse(cryptoData['buy']),
          );
        } else {
          currencies.add(CryptoCurrency(
            key: key,
            name: cryptoData['name'],
            wazirxPrice: double.parse(cryptoData['buy']),
            krakenPrice: 0.0,
            difference: 0,
          ));
        }
      }
    }

    return currencies;
  }
}
