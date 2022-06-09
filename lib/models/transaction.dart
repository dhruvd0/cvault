import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:cvault/models/profile_models/profile.dart';

class Transaction extends Equatable {
  Transaction({
    required this.id,
    required this.sender,
    required this.customer,
    required this.transactionType,
    required this.currency,
    required this.cryptoType,
    required this.price,
    required this.costPrice,
    required this.quantity,
    required this.status,
  });

  final String id;
  final Profile sender;
  final Profile customer;
  final String transactionType;
  final String currency;
  final String cryptoType;
  final double price;
  final double costPrice;
  final double quantity;
  final String status;

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sender": sender,
        "customer": customer,
        "transactionType": transactionType,
        "currency": currency,
        "cryptoType": cryptoType,
        "price": price,
        "costPrice": costPrice,
        "quantity": quantity,
        "status": status,
      };

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
    });
  }


  factory Transaction.fromJson(
    Map<String, dynamic> map, {
    String receiver = 'transaction',
  }) {
    return Transaction(
      id: map['id'] ?? '',
      sender: Profile.fromMap(map['sender'] ?? {}),
      customer: Profile.fromMap(map['customer'] ?? {}),
      transactionType: map['transactionType'] ?? '',
      currency: map['currency'] ?? '',
      cryptoType: map['cryptoType'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      costPrice: map['costPrice']?.toDouble() ?? 0.0,
      quantity: map['quantity']?.toDouble() ?? 0,
      status: map['status'] ?? '',
    );
  }

  @override
  List<Object> get props {
    return [
      id,
      sender,
      customer,
      transactionType,
      currency,
      cryptoType,
      price,
      costPrice,
      quantity,
      status,
    ];
  }

  Transaction copyWith({
    String? id,
    Profile? sender,
    Profile? customer,
    String? transactionType,
    String? currency,
    String? cryptoType,
    double? price,
    double? costPrice,
    double? quantity,
    String? status,
  }) {
    return Transaction(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      customer: customer ?? this.customer,
      transactionType: transactionType ?? this.transactionType,
      currency: currency ?? this.currency,
      cryptoType: cryptoType ?? this.cryptoType,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
    );
  }
}

enum TransactionProps {
  id,
  sender,
  customer,
  transactionType,
  currency,
  cryptoType,
  price,
  costPrice,
  quantity,
  status,
}
