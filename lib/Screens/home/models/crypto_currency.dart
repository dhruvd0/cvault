import 'dart:convert';

import 'package:equatable/equatable.dart';

class CryptoCurrency extends Equatable {
  /// The code name of the currency
  ///
  /// For example: btcinr
  final String key;

  /// Price retrieved from wazirx api
  final double wazirxPrice;

  /// Price retrieved from kraken api
  final double krakenPrice;

  /// Diffeence between wazirx and kraken
  final double difference;

  final String name;
  const CryptoCurrency({
    required this.key,
    required this.wazirxPrice,
    required this.krakenPrice,
    required this.difference,
    required this.name,
  });

  CryptoCurrency copyWith({
    String? key,
    double? wazirxPrice,
    double? krakenPrice,
    double? difference,
    String? name,
  }) {
    return CryptoCurrency(
      key: key ?? this.key,
      wazirxPrice: wazirxPrice ?? this.wazirxPrice,
      krakenPrice: krakenPrice ?? this.krakenPrice,
      difference: difference ?? this.difference,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'wazirxPrice': wazirxPrice,
      'krakenPrice': krakenPrice,
      'difference': difference,
      'name': name,
    };
  }

  factory CryptoCurrency.fromMap(Map<String, dynamic> map) {
    return CryptoCurrency(
      key: map['key'] ?? '',
      wazirxPrice: map['wazirxPrice']?.toDouble() ?? 0.0,
      krakenPrice: map['krakenPrice']?.toDouble() ?? 0.0,
      difference: map['difference']?.toDouble() ?? 0.0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'CryptoCurrency(key: $key, wazirxPrice: $wazirxPrice, krakenPrice: $krakenPrice, difference: $difference, name: $name)';
  }

  @override
  List<Object> get props {
    return [
      key,
      wazirxPrice,
      krakenPrice,
      difference,
      name,
    ];
  }
}
