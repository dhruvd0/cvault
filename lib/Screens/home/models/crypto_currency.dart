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
    
  });

  ///
  CryptoCurrency copyWith({
    String? wazirxKey,
    String? krakenKey,
    double? wazirxBuyPrice,
   
    double? krakenPrice,
    String? name,
  }) {
    return CryptoCurrency(
      wazirxKey: wazirxKey ?? this.wazirxKey,
      krakenKey: krakenKey ?? this.krakenKey,
      wazirxBuyPrice: wazirxBuyPrice ?? this.wazirxBuyPrice,
    
      krakenPrice: krakenPrice ?? this.krakenPrice,
      name: name ?? this.name,
    );
  }

  ///
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wazirxKey': wazirxKey,
      'krakenKey': krakenKey,
      'wazirxBuyPrice': wazirxBuyPrice,
      'krakenPrice': krakenPrice,
      'name': name,
    };
  }

  ///

  factory CryptoCurrency.fromMap(Map<String, dynamic> map) {
    return CryptoCurrency(
      wazirxKey: (map['wazirxKey'] ?? '') as String,
      krakenKey: (map['krakenKey'] ?? '') as String,
      wazirxBuyPrice: (map['wazirxBuyPrice'] ?? 0.0) as double,
      krakenPrice: (map['krakenPrice'] ?? 0.0) as double,
      name: (map['name'] ?? '') as String,
    );
  }

  ///
  String toJson() => json.encode(toMap());

 
  @override
  List<Object> get props {
    return [
      wazirxKey,
      krakenKey,
      wazirxBuyPrice,
      krakenPrice,
      name,
    ];
  }
}
