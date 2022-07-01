// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

///
class CryptoCurrency extends Equatable {
  /// The code name of the currency
  /// For example: btc
  final String key;

  /// Price retrieved from wazirx api
  final double wazirxBuyPrice;

  /// Price retrieved from kraken api
  final double krakenPrice;

  ///
  final String name;

  ///
  const CryptoCurrency({
    required this.key,
    required this.wazirxBuyPrice,
    required this.krakenPrice,
    required this.name,
  });

  ///
  CryptoCurrency copyWith({
    String? key,
    double? wazirxBuyPrice,
    double? krakenPrice,
    String? name,
  }) {
    return CryptoCurrency(
      key: key ?? this.key,
      wazirxBuyPrice: wazirxBuyPrice ?? this.wazirxBuyPrice,
      krakenPrice: krakenPrice ?? this.krakenPrice,
      name: name ?? this.name,
    );
  }

  ///
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'key': key,
      'wazirxBuyPrice': wazirxBuyPrice,
      'krakenPrice': krakenPrice,
      'name': name,
    };
  }

  ///

  factory CryptoCurrency.fromMap(Map<String, dynamic> map) {
    return CryptoCurrency(
      key: (map['key'] ?? '') as String,
      wazirxBuyPrice: (map['wazirxBuyPrice'] ?? 0.0) as double,
      krakenPrice: (map['krakenPrice'] ?? 0.0) as double,
      name: (map['name'] ?? '') as String,
    );
  }

  ///
  String toJson() => json.encode(toMap());

  @override
  List<Object> get props => [key, wazirxBuyPrice, krakenPrice, name];
}
