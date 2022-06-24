import 'dart:convert';

import 'package:cvault/constants/strings.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/util/http.dart';

import 'package:http/http.dart' as http;

class TransactionsProvider extends LoadStatusNotifier {
  final ProfileChangeNotifier profileChangeNotifier;
  List<Transaction> _transactions = [];

  TransactionsProvider(this.profileChangeNotifier) {
    profileChangeNotifier.addListener(() {
      if (profileChangeNotifier.loadStatus == LoadStatus.done &&
          profileChangeNotifier.token.isNotEmpty) {
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
        "$backendBaseUrl/transaction/${getAllTransactions ? 'getAllTransaction' : 'get-transaction'}",
      ),
      headers: header,
    );

    if (response.statusCode == 200) {
      _transactions = _parseTransactionsFromJsonData(
        response,
      ).reversed.toList();

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
    final List<dynamic> data = body is Map ? body['fetchTrans'] : body;
    for (var tr in data) {
      transactions.add(Transaction.fromJson(tr));
    }

    return transactions;
  }

  Future<void> changeTransactionStatus(
    String transactionID,
    TransactionStatus status,
  ) async {
    final response = await http.post(
      Uri.parse(
        "$backendBaseUrl/transaction/edit-trans",
      ),
      body: jsonEncode({
        {"transactionId": transactionID, "status": status.name},
      }),
      headers: defaultAuthenticatedHeader(profileChangeNotifier.token),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> trUpdated = jsonDecode(response.body);
      int index =
          _transactions.indexWhere((element) => element.id == transactionID);
      _transactions[index] = Transaction.fromJson(trUpdated["updated"]);
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }
  }
}
