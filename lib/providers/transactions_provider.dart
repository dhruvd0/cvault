import 'dart:convert';

import 'package:cvault/constants/strings.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/util/http.dart';
import 'package:cvault/util/ui.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TransactionsProvider extends LoadStatusNotifier {
  final ProfileChangeNotifier profileChangeNotifier;
  List<Transaction> _transactions = [];

  TransactionsProvider(this.profileChangeNotifier) {
    profileChangeNotifier.addListener(() async {
      if (profileChangeNotifier.loadStatus == LoadStatus.done &&
          profileChangeNotifier.token.isNotEmpty) {
        await getTransactions();
      } else {
        _transactions = [];
        notifyListeners();
      }
    });
  }

  Future<void> getTransactions() async {
    if (profileChangeNotifier.profile.userType == UserTypes.admin) {
      await _getAllTransactions();
    } else {
      await _getDealerTransaction(profileChangeNotifier.profile.uid);
    }
  }

  List<Transaction> get transactions {
    return [..._transactions];
  }

  Future<void> _getAllTransactions() async {
    await _getDealerTransaction('', getAllTransactions: true);
  }

  // To get transactions for a dealer
  Future<void> _getDealerTransaction(
    String dealerId, {
    bool getAllTransactions = false,
  }) async {
    loadStatus = LoadStatus.loading;
    notifyListeners();
    if (profileChangeNotifier.token.isEmpty) {
      await profileChangeNotifier.login(
        profileChangeNotifier.authInstance.currentUser!.uid,
      );
    }
    Map<String, String>? header = {
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${profileChangeNotifier.token}',
    };

    final response = await http.get(
      Uri.parse(
        "$backendBaseUrl/transaction/${getAllTransactions ? 'getAllTransaction' : 'get-transaction'}?page=$page",
      ),
      headers: header,
    );

    if (response.statusCode == 200) {
      _transactions.addAll(
        _parseTransactionsFromJsonData(
          response,
        ).toList(),
      );

      loadStatus = LoadStatus.done;
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }

    notifyListeners();
  }

  List<Transaction> _parseTransactionsFromJsonData(
    http.Response response,
  ) {
    List<Transaction> transactions = [];
    var body = jsonDecode(response.body);
    final List<dynamic> data = body is Map ? body['docs'] : body;
    for (var tr in data) {
      transactions.add(Transaction.fromJson(tr));
    }

    return transactions;
  }

  Future<void> changeTransactionStatus(
    String transactionID,
    TransactionStatus status, [
    BuildContext? context,
  ]) async {
    var object = {"transID": transactionID, "status": status.name};
    var jsonEncode2 = jsonEncode(
      object,
    );
    int index =
        _transactions.indexWhere((element) => element.id == transactionID);
    _transactions[index] = _transactions[index].copyWith(status: status.name);
    notifyListeners();
    final response = await http.patch(
      Uri.parse(
        "$backendBaseUrl/transaction/changeStatus",
      ),
      body: jsonEncode2,
      headers: defaultAuthenticatedHeader(profileChangeNotifier.token),
    );

    if (response.statusCode == 200) {
      if (context == null) {
        return;
      }
      showSnackBar('Transaction ${status.name}', context);
    } else {
      throw Exception(response.statusCode);
    }
  }
}
