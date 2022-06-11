import 'package:equatable/equatable.dart';

import 'package:cvault/Screens/home/models/crypto_currency.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

/// State Handled by [HomeStateNotifier], used by [Dashboard]
class HomeState extends Equatable {
  ///
  const HomeState({
    required this.cryptoCurrencies,
    required this.isUSD,
    required this.selectedCurrencyKey,
    required this.loadStatus,
    required this.difference,
  });

  ///
  final List<CryptoCurrency> cryptoCurrencies;

  ///
  final bool isUSD;

  /// The current selected
  final String selectedCurrencyKey;

  ///
  final LoadStatus loadStatus;

  ///
  final double difference;

  @override
  List<Object> get props {
    return [
      cryptoCurrencies,
      isUSD,
      selectedCurrencyKey,
      loadStatus,
      difference,
    ];
  }

  ///
  HomeState copyWith({
    List<CryptoCurrency>? cryptoCurrencies,
    bool? isUSD,
    String? selectedCurrencyKey,
    LoadStatus? loadStatus,
    double? difference,
  }) {
    return HomeState(
      cryptoCurrencies: cryptoCurrencies ?? this.cryptoCurrencies,
      isUSD: isUSD ?? this.isUSD,
      selectedCurrencyKey: selectedCurrencyKey ?? this.selectedCurrencyKey,
      loadStatus: loadStatus ?? this.loadStatus,
      difference: difference ?? this.difference,
    );
  }

  @override
  String toString() {
    return 'HomeState(cryptoCurrencies: $cryptoCurrencies, isUSD: $isUSD, selectedCurrencyKey: $selectedCurrencyKey, loadStatus: $loadStatus)';
  }
}

///
class HomeInitial extends HomeState {
  ///
  HomeInitial()
      : super(
          cryptoCurrencies: [],
          selectedCurrencyKey: HomeStateNotifier.cryptoKeys('inr').first,
          isUSD: false,
          loadStatus: LoadStatus.initial,
          difference: 0,
        );
}

///
class HomeData extends HomeState {
  ///
  const HomeData({
    required List<CryptoCurrency> cryptoCurrencies,
    required String selectedCurrencyKey,
    required bool isUSD,
    required LoadStatus loadStatus,
  }) : super(
          cryptoCurrencies: cryptoCurrencies,
          selectedCurrencyKey: selectedCurrencyKey,
          isUSD: isUSD,
          loadStatus: loadStatus,
          difference: 0.0,
        );
}
