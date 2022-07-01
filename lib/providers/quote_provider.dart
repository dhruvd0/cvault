// ignore_for_file:  sort_constructors_first
// ignore_for_file: public_member_api_docs

import 'dart:convert';

import 'package:cvault/providers/notification_bloc/notification_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

import 'package:cvault/models/home_state.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

enum QuoteMode {
  Price,
  Quantity,
}

class QuoteProvider extends LoadStatusNotifier {
  Transaction transaction =
      Transaction.fromJson({TransactionProps.transactionType.name: 'buy'});
  final HomeStateNotifier homeStateNotifier;

  final ProfileChangeNotifier profileChangeNotifier;
  var quoteMode = QuoteMode.Price;
  void changeQuoteMode(QuoteMode mode) {
    quoteMode = mode;
    notifyListeners();
  }

  QuoteProvider({
    required this.homeStateNotifier,
    required this.profileChangeNotifier,
  }) {
    homeStateNotifier.addListener(() {
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
    HomeState homeState = homeStateNotifier.state;

    transaction =
        transaction.copyWith(cryptoType: homeState.selectedCurrencyKey);
    transaction =
        transaction.copyWith(currency: homeState.isUSD ? 'usdt' : 'inr');

    if (homeState.cryptoCurrencies.isNotEmpty) {
      try {
        var crypto = homeStateNotifier.currentCryptoCurrency();
        transaction = transaction.copyWith(
          costPrice: transaction.transactionType == 'sell'
              ? crypto.krakenPrice
              : crypto.wazirxBuyPrice,
        );
        notifyListeners();
      } on StateError {
        // TODO
      }
    }
    notifyListeners();
  }

  /// Returns [true] if successful,
  ///  [false] for 400, Bad Request(Customer not found)
  ///  and null for failure
  // ignore: long-method
  Future<bool?> sendQuote() async {
    loadStatus = LoadStatus.loading;

    notifyListeners();

    final response = await post(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/transaction/post-transaction",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer ${profileChangeNotifier.token}',
      },
      body: jsonEncode(
        _quoteDataFromTransactions(
          profileChangeNotifier.authInstance.currentUser!.uid,
        ),
      ),
    );

    if (response.statusCode == 201) {
      var decodedBody = jsonDecode(response.body);
      String title = 'Quote Received';
      String body =
          '${transaction.transactionType} | ${transaction.cryptoType} | ${transaction.price} ${transaction.currency} | ${transaction.quantity} ${transaction.cryptoType}';
      NotificationCubit.sendNotificationToUser(
        'Quote Sent',
        body,
        FirebaseAuth.instance.currentUser!.uid,
      );
      NotificationCubit.sendNotificationToUser(
        title,
        body,
        decodedBody['recieverUID'],
      );

      loadStatus = LoadStatus.done;

      notifyListeners();

      return true;
    } else if (response.statusCode == 400) {
      loadStatus = LoadStatus.done;
      notifyListeners();

      return false;
    } else {
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
      "timestamps": DateTime.now().toIso8601String(),
      "receiversPhone": transaction.receiver.phone,
      "sendersID": sendersID,
      'dealerMargin': homeStateNotifier.marginsNotifier.dealerMargin,
    };
  }

  void changeTransactionField(TransactionProps field, dynamic data) {
    switch (field) {
      case TransactionProps.receiver:
        transaction = transaction.copyWith(receiver: data);
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
        costPrice: homeStateNotifier.currentCryptoCurrency().wazirxBuyPrice,
      );
    } else if (data == 'sell') {
      transaction = transaction.copyWith(
        costPrice: homeStateNotifier.currentCryptoCurrency().krakenPrice,
      );
    }
    if (quoteMode == QuoteMode.Price) {
      changeTransactionField(TransactionProps.quantity, transaction.quantity);
    } else {
      changeTransactionField(TransactionProps.price, transaction.price);
    }
    notifyListeners();
  }
}
