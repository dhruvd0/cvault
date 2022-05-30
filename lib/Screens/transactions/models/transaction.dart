import 'dart:convert';

import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String transactionId;

  /// "buy" or "sell"
  final String transactionType;

  /// crypto name, for example: btcinr
  final String cryptoType;

   /// cost of 1 unit crypto currency
  final double price;

  /// Total price
  final double costPrice;

  final double quantity;
  final String accepted;
  /// "USD" or "INR"
  final String currency;
  final String sendersID;
  final String status;
  final String receiversPhone;
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
    required this.sendersID,
    required this.status,
    required this.receiversPhone,
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
    String? sendersID,
    String? status,
    String? receiversPhone,
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
      sendersID: sendersID ?? this.sendersID,
      status: status ?? this.status,
      receiversPhone: receiversPhone ?? this.receiversPhone,
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
      'sendersID': sendersID,
      'status': status,
      'receiversPhone': receiversPhone,
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
      sendersID: map['sendersID'] ?? '',
      status: map['status'] ?? '',
      receiversPhone: map['receiversPhone'] ?? '',
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Transaction(transactionId: $transactionId, transactionType: $transactionType, cryptoType: $cryptoType, price: $price, costPrice: $costPrice, quantity: $quantity, accepted: $accepted, currency: $currency, sendersID: $sendersID, status: $status, receiversPhone: $receiversPhone, userName: $userName)';
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
      sendersID,
      status,
      receiversPhone,
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
