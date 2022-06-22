import 'dart:convert';

import 'package:cvault/constants/strings.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

class TransactionsProvider extends LoadStatusNotifier {
  final ProfileChangeNotifier profileChangeNotifier;
  List<Transaction> _transactions = [];

  TransactionsProvider(this.profileChangeNotifier) {
    profileChangeNotifier.addListener(() {
      if (profileChangeNotifier.loadStatus == LoadStatus.done) {
        if (profileChangeNotifier.profile.userType == UserTypes.admin) {
          getAllTransactions();
        } else {
          getDealerTransaction(profileChangeNotifier.profile.uid);
        }
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
    await getDealerTransaction('', getAllTransactions: true);
  }

  // To get transactions for a dealer
  Future<void> getDealerTransaction(
    String dealerId, {
    bool getAllTransactions = false,
  }) async {
    loadStatus = LoadStatus.loading;
    notifyListeners();
    if (profileChangeNotifier.jwtToken.isEmpty) {
      await profileChangeNotifier.login(profileChangeNotifier.authInstance.currentUser!.uid);
    }
    Map<String, String>? header = {
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${profileChangeNotifier.jwtToken}',
    };

    final response = getAllTransactions
        ? await http.get(
            Uri.parse(
              "$backendBaseUrl/transaction/getAllTransaction",
            ),
            headers: header,
          )
        : await http.get(
            Uri.parse(
              "$backendBaseUrl/transaction/get-transaction",
            ),
          
            headers: header,
          );

    if (response.statusCode == 200) {
      List<Transaction> transactions = [];

      _parseTransactionsFromJsonData(response, transactions);
      _transactions = transactions;
      _transactions = _transactions.reversed.toList();
      loadStatus = LoadStatus.done;
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }

    notifyListeners();
  }

  void _parseTransactionsFromJsonData(
    http.Response response,
    List<Transaction> transactions,
  ) {
    var body = jsonDecode(response.body);
    final List<dynamic> data = body['fetchTrans'];
    for (var tr in data) {
      transactions.add(Transaction.fromJson(tr));
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
    } catch (error) {
      rethrow;
    }
  }
}
