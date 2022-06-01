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
  final double price;
  final double costPrice;
  final int quantity;
  final String status;

  factory Transaction.fromRawJson(String str) =>
      Transaction.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["_id"],
        sender: json["sender"]["firstName"],
        customer: json["customer"]["firstName"],
        transactionType: json["transactionType"],
        currency: json["currency"],
        cryptoType: json["cryptoType"],
        price: (json["price"] ?? 0).toDouble(),
        costPrice: (json["costPrice"] ?? 0.0).toDouble(),
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
}
