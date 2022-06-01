import 'dart:convert';

import 'package:cvault/constants/strings.dart';
import 'package:cvault/models/transaction.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class TransactionsProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  String? _loadedTransactions;

  List<Transaction> get transactions {
    return [..._transactions];
  }

  bool isLoadedTransactions({required String retriever}) {
    if (_loadedTransactions == null) {
      return false;
    }

    return _loadedTransactions == retriever;
  }

  Future<void> getAllTransactions() async {
    // TODO: API not available to get all transactions for Admin
  }

  // To get transactions for a dealer
  // ignore: long-method
  Future<void> getDealerTransaction(String dealerId) async {
    try {
      final response = await http.post(
        Uri.parse(
          "$backendBaseUrl/transaction/get-transaction",
        ),
        body: jsonEncode(
          {
            "dealerId": dealerId,
          },
        ),
      );

      print(response.body);

      if (response.statusCode == 200) {
        List<Transaction> transactions = [];

        final List<dynamic> data = jsonDecode(response.body);
        data.forEach(
          (tr) {
            transactions.add(Transaction.fromJson(tr));
          },
        );

        _transactions = transactions;
        _loadedTransactions = dealerId;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      rethrow;
    }
  }

  Future<void> changeTransactionStatus(int index, String status) async {
    try {
      final response = await http.post(
        Uri.parse(
          "$backendBaseUrl/transaction/edit-trans",
        ),
        body: jsonEncode({
          {"transactionId": _transactions[index].id, "status": status},
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> trUpdated = jsonDecode(response.body);
        _transactions[index] = Transaction.fromJson(trUpdated["updated"]);
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      rethrow;
    }
  }

  // ignore: long-parameter-list
  Future<void> createTransaction(
    String trType,
    String cryptoType,
    double price,
    String currency,
    int quantity,
    String rcPhone,
    String sdId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$backendBaseUrl/transaction/post-transaction"),
        body: jsonEncode({
          "transactionType": "abc",
          "cryptoType": "bitcoin",
          "price": 500,
          "costPrice": 700,
          "currency": "inr",
          "quantity": 5,
          "receiversPhone": "1234567890",
          "sendersID": "1234",
        }),
      );

      if (response.statusCode == 200) {
        // TODO: error in api, save in all transactions as new transaction here
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      rethrow;
    }
  }
}
