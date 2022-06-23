// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final double wazirxBuyPrice;

  /// sell price
  final double wazirxSellPrice;

  /// Price retrieved from kraken api
  final double krakenPrice;

  ///
  final String name;

  ///
  const CryptoCurrency({
    required this.wazirxKey,
    required this.krakenKey,
    required this.wazirxBuyPrice,
    required this.krakenPrice,
    required this.name,
    required this.wazirxSellPrice,
  });

  ///
  CryptoCurrency copyWith({
    String? wazirxKey,
    String? krakenKey,
    double? wazirxBuyPrice,
    double? wazirxSellPrice,
    double? krakenPrice,
    String? name,
  }) {
    return CryptoCurrency(
      wazirxKey: wazirxKey ?? this.wazirxKey,
      krakenKey: krakenKey ?? this.krakenKey,
      wazirxBuyPrice: wazirxBuyPrice ?? this.wazirxBuyPrice,
      wazirxSellPrice: wazirxSellPrice ?? this.wazirxSellPrice,
      krakenPrice: krakenPrice ?? this.krakenPrice,
      name: name ?? this.name,
    );
  }

  ///
  Map<String, dynamic> toMap() {
    return {
      'wazirxKey': wazirxKey,
      'krakenKey': krakenKey,
      'wazirxPrice': wazirxBuyPrice,
      'krakenPrice': krakenPrice,
      'name': name,
      'sellPrice': wazirxSellPrice,
    };
  }

  ///

  factory CryptoCurrency.fromMap(Map<String, dynamic> map) {
    return CryptoCurrency(
      wazirxKey: map['wazirxKey'] ?? '',
      krakenKey: map['krakenKey'] ?? '',
      wazirxBuyPrice: map['wazirxPrice']?.toDouble() ?? 0.0,
      krakenPrice: map['krakenPrice']?.toDouble() ?? 0.0,
      name: map['name'] ?? '',
      wazirxSellPrice: map['sellprice']?.toDouble() ?? 0.0,
    );
  }

  ///
  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CryptoCurrency(wazirxKey: $wazirxKey, krakenKey: $krakenKey, wazirxPrice: $wazirxBuyPrice, krakenPrice: $krakenPrice, name: $name,sellPrice:$wazirxSellPrice)';
  }

  @override
  List<Object> get props {
    return [
      wazirxKey,
      krakenKey,
      wazirxBuyPrice,
      krakenPrice,
      name,
      wazirxSellPrice,
    ];
  }
}
