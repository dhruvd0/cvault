import 'dart:convert';
import 'dart:developer';

import 'package:cvault/models/home_state.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class QuoteProvider extends ChangeNotifier {
  Transaction transaction =
      Transaction.fromJson({TransactionProps.transactionType.name: 'buy'});
  final HomeStateNotifier _homeStateNotifier;
  final ProfileChangeNotifier _profileChangeNotifier;
  QuoteProvider(this._homeStateNotifier, this._profileChangeNotifier) {
    _homeStateNotifier.addListener(() {
      updateWithHomeNotifierState();
    });
    _profileChangeNotifier.addListener(() {
      updateWithProfileProviderState();
    });
  }
  void updateWithProfileProviderState() {
    Profile profile = _profileChangeNotifier.profile;

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
      var crypto = _homeStateNotifier.currentCryptoCurrency();
      transaction = transaction.copyWith(costPrice: crypto.wazirxPrice);
    }
    notifyListeners();
  }

  Future<bool> sendQuote() async {
    String sendersID =  _profileChangeNotifier.authInstance.currentUser.uid;
    Map<String, dynamic> quoteData = {
      "transactionType": transaction.transactionType,
      "cryptoType": transaction.cryptoType,
      "price": transaction.price,
      "costPrice": transaction.costPrice,
      "currency": transaction.currency,
      "quantity": transaction.quantity,
      "receiversPhone": transaction.customer.phone,
      "sendersID":sendersID,
    };

    final response = await post(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/transaction/post-transaction",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(quoteData),
    );

    if (response == 201) {
      return true;
    } else {
      throw Exception('post-transaction:' + response.statusCode.toString());
    }
  }

  void changeTransactionField(TransactionProps field, dynamic data) {
    switch (field) {
      case TransactionProps.customer:
        transaction = transaction.copyWith(customer: data);
        break;
      case TransactionProps.transactionType:
        transaction = transaction.copyWith(transactionType: data);
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
}
