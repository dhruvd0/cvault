import 'dart:convert';

import 'package:equatable/equatable.dart';
///
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

  /// sell price
  final double sellPrice;

  /// Price retrieved from kraken api
  final double krakenPrice;
  ///
  final String name;
  ///
  const CryptoCurrency({
    required this.wazirxKey,
    required this.krakenKey,
    required this.wazirxPrice,
    required this.krakenPrice,
    required this.name,
    required this.sellPrice,
  });
  ///
  CryptoCurrency copyWith({
    String? wazirxKey,
    String? krakenKey,
    double? wazirxPrice,
    double? krakenPrice,
    String? name,
    double? sellPrice,
  }) {
    return CryptoCurrency(
      wazirxKey: wazirxKey ?? this.wazirxKey,
      krakenKey: krakenKey ?? this.krakenKey,
      wazirxPrice: wazirxPrice ?? this.wazirxPrice,
      krakenPrice: krakenPrice ?? this.krakenPrice,
      name: name ?? this.name,
      sellPrice: sellPrice ?? this.sellPrice,
    );
  }
  ///
  Map<String, dynamic> toMap() {
    return {
      'wazirxKey': wazirxKey,
      'krakenKey': krakenKey,
      'wazirxPrice': wazirxPrice,
      'krakenPrice': krakenPrice,
      'name': name,
      'sellPrice': sellPrice,
    };
  }
  ///

  factory CryptoCurrency.fromMap(Map<String, dynamic> map) {
    return CryptoCurrency(
      wazirxKey: map['wazirxKey'] ?? '',
      krakenKey: map['krakenKey'] ?? '',
      wazirxPrice: map['wazirxPrice']?.toDouble() ?? 0.0,
      krakenPrice: map['krakenPrice']?.toDouble() ?? 0.0,
      name: map['name'] ?? '',
      sellPrice: map['sellprice']?.toDouble() ?? 0.0,
    );
  }
  ///
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CryptoCurrency(wazirxKey: $wazirxKey, krakenKey: $krakenKey, wazirxPrice: $wazirxPrice, krakenPrice: $krakenPrice, name: $name,sellPrice:$sellPrice)';
  }

  @override
  List<Object> get props {
    return [
      wazirxKey,
      krakenKey,
      wazirxPrice,
      krakenPrice,
      name,
      sellPrice,
    ];
  }
}
