import 'package:cvault/models/home_state.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:flutter/cupertino.dart';

class QuoteProvider extends ChangeNotifier {
  Transaction transaction =
      Transaction.fromJson({TransactionProps.transactionType.name: 'buy'});
  final HomeStateNotifier _homeStateNotifier;
  final ProfileChangeNotifier _profileChangeNotifier;
  QuoteProvider(this._homeStateNotifier, this._profileChangeNotifier) {
    _homeStateNotifier.addListener(() {
      homeNotifierListener();
    });
    _profileChangeNotifier.addListener(() {
      profileProviderListener();
    });
  }
  void profileProviderListener() {
    Profile profile = _profileChangeNotifier.profile;
    if (profile.uid.isNotEmpty) {
      transaction = transaction.copyWith(sender: profile);
    }
    notifyListeners();
  }

  void homeNotifierListener() {
    HomeState homeState = _homeStateNotifier.state;

    transaction =
        transaction.copyWith(cryptoType: homeState.selectedCurrencyKey);
    transaction =
        transaction.copyWith(currency: homeState.isUSD ? 'usdt' : 'inr');
    if (homeState.cryptoCurrencies.isNotEmpty) {
      var crypto = _homeStateNotifier.currentCryptoCurrency();
      transaction = transaction.copyWith(costPrice: crypto.wazirxPrice);
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
          quantity: transaction.costPrice/ transaction.price,
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
