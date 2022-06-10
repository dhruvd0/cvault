import 'dart:convert';

import 'package:cvault/constants/strings.dart';
import 'package:cvault/models/transaction.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:http/http.dart' as http;

class TransactionsProvider extends LoadStatusNotifier {
  ProfileChangeNotifier profileChangeNotifier;
  List<Transaction> _transactions = [];

  TransactionsProvider(this.profileChangeNotifier) {
    profileChangeNotifier.addListener(() {
      if (profileChangeNotifier.loadStatus == LoadStatus.done) {
        getDealerTransaction(profileChangeNotifier.profile.uid);
      } else {
        _transactions = [];
        notifyListeners();
      }
    });
  }

  List<Transaction> get transactions {
    return [..._transactions];
  }

  Future<void> getAllTransactions() async {
    // TODO: API not available to get all transactions for Admin
  }

  // To get transactions for a dealer
  // ignore: long-method
  Future<void> getDealerTransaction(String dealerId) async {
    try {
      loadStatus = LoadStatus.loading;
      notifyListeners();
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
        loadStatus = LoadStatus.done;
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
}
