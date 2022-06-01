// To parse this JSON data, do
//
//     final dealer = dealerFromJson(jsonString);

import 'dart:convert';

import 'package:cvault/models/transaction.dart';

class Dealer {
  Dealer({
    required this.id,
    required this.dealerId,
    required this.name,
    required this.phone,
    required this.email,
    required this.active,
    required this.transactions,
  });

  final String id;
  final String dealerId;
  final String name;
  final String phone;
  final String email;
  final bool active;
  final List<Transaction> transactions;

  factory Dealer.fromRawJson(String str) => Dealer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dealer.fromJson(Map<String, dynamic> json) => Dealer(
        id: json["_id"],
        dealerId: json["dealerId"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        active: json["active"],
        transactions: List<Transaction>.from(
          json["transactions"].map((x) => Transaction.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "dealerId": dealerId,
        "name": name,
        "phone": phone,
        "email": email,
        "active": active,
        "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
      };
}
