import 'dart:math';

import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/mocks.dart';

void main() {
  group('Quote Provider Tests', () {
    test(
      'Test to change quote quantity',
      () async {
        QuoteProvider quoteProvider = await setupQuoteProvider();

        expect(quoteProvider.transaction.cryptoType, isNotEmpty);
        quoteProvider.changeTransactionField(TransactionProps.quantity, 12.5);
        expect(quoteProvider.transaction.quantity, 12.5);
        expect(
          quoteProvider.transaction.price,
          quoteProvider.transaction.costPrice * 12.5,
        );
      },
    );

    test('Test to send a quote', () async {
      await (await SharedPreferences.getInstance()).clear();
      QuoteProvider quoteProvider = await setupQuoteProvider();

      quoteProvider.changeTransactionField(
        TransactionProps.customer,
        Profile.fromMap(
          const {'phone': '1234567890', 'customerId': ''},
        ),
      );
      double randomQuantity =
          Random().nextInt(100).toDouble() + Random().nextDouble();

      quoteProvider.changeTransactionField(
        TransactionProps.quantity,
        randomQuantity,
      );

      final success = await quoteProvider.sendQuote();
      expect(success, true);
      final transactionsProvider =
          TransactionsProvider(quoteProvider.profileChangeNotifier);
      await transactionsProvider
          .getDealerTransaction(mockAuth.currentUser!.uid);
      expect(
        transactionsProvider.transactions
            .any((element) => element.quantity == randomQuantity),
        true,
      );
    });
  });
}
