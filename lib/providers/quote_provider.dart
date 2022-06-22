// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:cvault/models/home_state.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:http/http.dart';

class QuoteProvider extends LoadStatusNotifier {
  // ignore: public_member_api_docs
  Transaction transaction =
      Transaction.fromJson({TransactionProps.transactionType.name: 'buy'});
  final HomeStateNotifier _homeStateNotifier;
  // ignore: public_member_api_docs
  final ProfileChangeNotifier profileChangeNotifier;
  QuoteProvider(this._homeStateNotifier, this.profileChangeNotifier) {
    _homeStateNotifier.addListener(() {
      updateWithHomeNotifierState();
    });
    profileChangeNotifier.addListener(() {
      updateWithProfileProviderState();
    });
  }
  void updateWithProfileProviderState() {
    Profile profile = profileChangeNotifier.profile;

    if (profile.uid.isNotEmpty) {
      transaction = transaction.copyWith(sender: profile);
    }
    notifyListeners();
  }

  void updateWithHomeNotifierState() {
    HomeState homeState = _homeStateNotifier.state;

    transaction =
        transaction.copyWith(cryptoType: homeState.selectedCurrencyKey);
    transaction =
        transaction.copyWith(currency: homeState.isUSD ? 'usdt' : 'inr');
    if (homeState.cryptoCurrencies.isNotEmpty) {
      try {
        var crypto = _homeStateNotifier.currentCryptoCurrency();
        transaction = transaction.copyWith(
          costPrice: transaction.transactionType == 'sell'
              ? crypto.sellPrice
              : crypto.wazirxPrice,
        );
      } on StateError {
        // TODO
      }
    }
    notifyListeners();
  }

  /// Returns [true] if successful,
  ///  [false] for 400, Bad Request(Customer not found)
  ///  and null for failure
  Future<bool?> sendQuote() async {
    String sendersID = profileChangeNotifier.authInstance.currentUser!.uid;
    Map<String, dynamic> quoteData = _quoteDataFromTransactions(sendersID);

    loadStatus = LoadStatus.loading;

    notifyListeners();
    
    assert(profileChangeNotifier.jwtToken.isNotEmpty);
    Map<String, String>? header = {
      "Content-Type": "application/json",
      "Authorization": 'Bearer ${profileChangeNotifier.jwtToken}',
    };

    final response = await post(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/transaction/post-transaction",
      ),
      headers: header,
      body: jsonEncode(quoteData),
    );

    if (response.statusCode == 201) {
      transaction = Transaction.fromJson(
        {TransactionProps.transactionType.name: 'buy'},
      );
      loadStatus = LoadStatus.done;
      notifyListeners();

      return true;
    } else if (response.statusCode == 400) {
      loadStatus = LoadStatus.done;
      notifyListeners();

      return false;
    } else {
      loadStatus = LoadStatus.error;
      notifyListeners();
      throw Exception('post-transaction:${response.statusCode}');
    }
  }

  Map<String, dynamic> _quoteDataFromTransactions(String sendersID) {
    return {
      "transactionType": transaction.transactionType,
      "cryptoType": transaction.cryptoType,
      "price": transaction.price,
      "costPrice": transaction.costPrice,
      "currency": transaction.currency,
      "quantity": transaction.quantity,
      "receiversPhone": transaction.customer.phone,
      "sendersID": sendersID,
      "sender type": profileChangeNotifier.profile.userType,
    };
  }

  void changeTransactionField(TransactionProps field, dynamic data) {
    switch (field) {
      case TransactionProps.customer:
        transaction = transaction.copyWith(customer: data);
        break;
      case TransactionProps.transactionType:
        _changeTransactionType(data);
        break;

      case TransactionProps.price:
        transaction = transaction.copyWith(price: data);
        transaction = transaction.copyWith(
          quantity: transaction.costPrice / transaction.price,
        );
        break;

      case TransactionProps.quantity:
        transaction = transaction.copyWith(quantity: data);
        transaction = transaction.copyWith(
          price: transaction.costPrice * transaction.quantity,
        );
        break;
      default:
    }

    notifyListeners();
  }

  void _changeTransactionType(data) {
    transaction = transaction.copyWith(transactionType: data);
    if (data == 'buy') {
      transaction = transaction.copyWith(
        costPrice: _homeStateNotifier.currentCryptoCurrency().wazirxPrice,
      );
      print(transaction);
    } else if (data == 'sell') {
      transaction = transaction.copyWith(
        costPrice: _homeStateNotifier.currentCryptoCurrency().sellPrice,
      );
      print(transaction);
    }
  }
}
