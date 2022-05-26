import 'dart:convert';

import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String transactionId;
  final String transactionType;
  final String cryptoType;
  final double price;
  final double costPrice;
  final double quantity;
  final String accepted;
  final String currency;
  final String valueType;
  final String status;
  final String userID;
  final String userName;
  const Transaction({
    required this.transactionId,
    required this.transactionType,
    required this.cryptoType,
    required this.price,
    required this.costPrice,
    required this.quantity,
    required this.accepted,
    required this.currency,
    required this.valueType,
    required this.status,
    required this.userID,
    required this.userName,
  });

  Transaction copyWith({
    String? transactionId,
    String? transactionType,
    String? cryptoType,
    double? price,
    double? costPrice,
    double? quantity,
    String? accepted,
    String? currency,
    String? valueType,
    String? status,
    String? userID,
    String? userName,
  }) {
    return Transaction(
      transactionId: transactionId ?? this.transactionId,
      transactionType: transactionType ?? this.transactionType,
      cryptoType: cryptoType ?? this.cryptoType,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      accepted: accepted ?? this.accepted,
      currency: currency ?? this.currency,
      valueType: valueType ?? this.valueType,
      status: status ?? this.status,
      userID: userID ?? this.userID,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'transactionId': transactionId,
      'transactionType': transactionType,
      'cryptoType': cryptoType,
      'price': price,
      'costPrice': costPrice,
      'quantity': quantity,
      'accepted': accepted,
      'currency': currency,
      'valueType': valueType,
      'status': status,
      'userID': userID,
      'userName': userName,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      transactionId: map['transactionId'] ?? '',
      transactionType: map['transactionType'] ?? '',
      cryptoType: map['cryptoType'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      costPrice: map['costPrice']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toDouble() ?? 0.0,
      accepted: map['accepted'] ?? '',
      currency: map['currency'] ?? '',
      valueType: map['valueType'] ?? '',
      status: map['status'] ?? '',
      userID: map['userID'] ?? '',
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Transaction(transactionId: $transactionId, transactionType: $transactionType, cryptoType: $cryptoType, price: $price, costPrice: $costPrice, quantity: $quantity, accepted: $accepted, currency: $currency, valueType: $valueType, status: $status, userID: $userID, userName: $userName)';
  }

  @override
  List<Object> get props {
    return [
      transactionId,
      transactionType,
      cryptoType,
      price,
      costPrice,
      quantity,
      accepted,
      currency,
      valueType,
      status,
      userID,
      userName,
    ];
  }

  static Transaction mock() {
    return Transaction.fromMap(const {
      'userName': 'Test Name',
      'price': 2300000000.1,
      'status': 'Receieved',
      'currency': 'INR',
    });
  }
}
