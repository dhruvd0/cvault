import 'dart:convert';

import 'package:equatable/equatable.dart';

class CryptoCurrency extends Equatable {
  /// The code name of the currency only for wazirx api
  ///
  /// For example: btcinr
  final String wazirxKey;

  /// The code name of the currency only for kraken api
  ///
  /// For example: BTCUSD
  final String krakenKey;

  /// Price retrieved from wazirx api
  final double wazirxPrice;

  /// Price retrieved from kraken api
  final double krakenPrice;



  final String name;
  const CryptoCurrency({
    required this.wazirxKey,
    required this.krakenKey,
    required this.wazirxPrice,
    required this.krakenPrice,
    required this.name,
  });

  CryptoCurrency copyWith({
    String? wazirxKey,
    String? krakenKey,
    double? wazirxPrice,
    double? krakenPrice,
    String? name,
  }) {
    return CryptoCurrency(
      wazirxKey: wazirxKey ?? this.wazirxKey,
      krakenKey: krakenKey ?? this.krakenKey,
      wazirxPrice: wazirxPrice ?? this.wazirxPrice,
      krakenPrice: krakenPrice ?? this.krakenPrice,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'wazirxKey': wazirxKey,
      'krakenKey': krakenKey,
      'wazirxPrice': wazirxPrice,
      'krakenPrice': krakenPrice,
      'name': name,
    };
  }

  factory CryptoCurrency.fromMap(Map<String, dynamic> map) {
    return CryptoCurrency(
      wazirxKey: map['wazirxKey'] ?? '',
      krakenKey: map['krakenKey'] ?? '',
      wazirxPrice: map['wazirxPrice']?.toDouble() ?? 0.0,
      krakenPrice: map['krakenPrice']?.toDouble() ?? 0.0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CryptoCurrency(wazirxKey: $wazirxKey, krakenKey: $krakenKey, wazirxPrice: $wazirxPrice, krakenPrice: $krakenPrice, name: $name)';
  }

  @override
  List<Object> get props {
    return [
      wazirxKey,
      krakenKey,
      wazirxPrice,
      krakenPrice,
      name,
    ];
  }
}
