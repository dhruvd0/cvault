// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:cvault/models/profile_models/profile.dart';

enum TransactionStatus {
  accepted,
  rejected,
  expired,
  sent,
}

/// Transaction Model
class Transaction extends Equatable {
  ///
  const Transaction({
    required this.costPrice,
    required this.cryptoType,
    required this.currency,
    required this.receiver,
    required this.id,
    required this.price,
    required this.quantity,
    required this.margin,
    required this.sender,
    required this.status,
    required this.transactionType,
    this.createdAt = '',
  });

  ///
  factory Transaction.fromJson(
    Map<String, dynamic> map,
  ) {
    return Transaction(
      id: map['_id'] ?? '',
      sender: Profile.fromMap(map['sender'] ?? {}),
      receiver: Profile.fromMap(map['receiver'] ?? {}),
      transactionType: map['transactionType'] ?? '',
      currency: map['currency'] ?? '',
      cryptoType: map['cryptoType'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      costPrice: map['costPrice']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toDouble() ?? 0,
      status: map['status'] ?? '',
      createdAt: map['createdAt'] ?? '',
      margin: map['margin']?.toDouble() ?? 0,
    );
  }

  ///
  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  /// Price of 1 crypto currency
  final double costPrice;

  /// Crypto key name, example: "btcinr"
  final String cryptoType;

  /// Can be either 'usdt' or 'inr
  final String currency;

  ///
  final Profile receiver;

  ///
  final String id;

  /// The total price of the transaction, usually [costPrice]*[quantity]
  final double price;

  /// The total quantity of the transaction
  final double quantity;

//margin

  final double margin;

  /// Sender
  final Profile sender;

  /// See [TransactionStatus]
  final String status;

  /// can be "buy" or "sell"
  final String transactionType;

  final String createdAt;

  @override
  List<Object> get props {
    return [
      id,
      sender,
      receiver,
      transactionType,
      currency,
      cryptoType,
      price,
      costPrice,
      quantity,
      status,
      margin,
    ];
  }

  ///
  String toRawJson() => json.encode(toJson());

  ///
  Map<String, dynamic> toJson() => {
        "_id": id,
        "sender": sender,
        "customer": receiver,
        "transactionType": transactionType,
        "currency": currency,
        "cryptoType": cryptoType,
        "price": price,
        "costPrice": costPrice,
        "quantity": quantity,
        "status": status,
        "margin": margin,
      };

  ///
  static Transaction mock() {
    return Transaction.fromJson(const {
      'userName': 'Test Name',
      'price': 2300000000.1,
      'status': 'Received',
      '_id': "1",
      'currency': 'INR',
      'sender': '',
      'customer': '',
      'transactionType': 'buy',
      'cryptoType': 'btcinr',
      'quantity': 1,
      'margin': 5,
    });
  }

  ///
  Transaction copyWith({
    double? costPrice,
    String? cryptoType,
    String? currency,
    Profile? receiver,
    String? id,
    double? price,
    double? quantity,
    double? margin,
    Profile? sender,
    String? status,
    String? transactionType,
    String? timestamps,
  }) {
    return Transaction(
      costPrice: costPrice ?? this.costPrice,
      cryptoType: cryptoType ?? this.cryptoType,
      currency: currency ?? this.currency,
      receiver: receiver ?? this.receiver,
      id: id ?? this.id,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      margin: margin ?? this.margin,
      sender: sender ?? this.sender,
      status: status ?? this.status,
      transactionType: transactionType ?? this.transactionType,
      createdAt: timestamps ?? createdAt,
    );
  }
}

///
enum TransactionProps {
  ///
  id,

  ///
  sender,

  ///
  receiver,

  ///
  transactionType,

  ///
  currency,

  ///
  cryptoType,

  ///
  price,

  ///
  costPrice,

  ///
  quantity,

  ///
  status,

  ///
  margin
}
