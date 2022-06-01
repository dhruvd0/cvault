import 'dart:convert';

class Transaction {
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
  final String sender;
  final String customer;
  final String transactionType;
  final String currency;
  final String cryptoType;
  final int price;
  final int costPrice;
  final int quantity;
  final String status;

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["_id"],
        sender: json["sender"],
        customer: json["customer"],
        transactionType: json["transactionType"],
        currency: json["currency"],
        cryptoType: json["cryptoType"],
        price: json["price"],
        costPrice: json["costPrice"],
        quantity: json["quantity"],
        status: json["status"],
      );

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
}
