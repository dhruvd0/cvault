import 'package:equatable/equatable.dart';

import 'package:cvault/Screens/home/models/crypto_currency.dart';

class HomeState extends Equatable {
  final List<CryptoCurrency> cryptoCurrencies;
  final String selectedCurrencyKey;
  final bool isUSD;
  const HomeState({
    required this.cryptoCurrencies,
    required this.selectedCurrencyKey,
    required this.isUSD,
  });

  @override
  List<Object> get props => [cryptoCurrencies, selectedCurrencyKey, isUSD];

  HomeState copyWith({
    List<CryptoCurrency>? cryptoCurrencies,
    String? selectedCurrencyKey,
    bool? isUSD,
  }) {
    return HomeState(
      cryptoCurrencies: cryptoCurrencies ?? this.cryptoCurrencies,
      selectedCurrencyKey: selectedCurrencyKey ?? this.selectedCurrencyKey,
      isUSD: isUSD ?? this.isUSD,
    );
  }
}

class HomeInitial extends HomeState {
  HomeInitial()
      : super(
          cryptoCurrencies: [],
          selectedCurrencyKey: '',
          isUSD: true,
        );
}

class HomeData extends HomeState {
  const HomeData({
    required List<CryptoCurrency> cryptoCurrencies,
    required String selectedCurrencyKey,
    required bool isUSD,
  }) : super(
          cryptoCurrencies: cryptoCurrencies,
          selectedCurrencyKey: selectedCurrencyKey,
          isUSD: isUSD,
        );
}
