import 'dart:math';

import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/quote_provider.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/mocks.dart';

void main() {
  group('Quote Provider Tests', () {
    test(
      'Test to change quote quantity',
      () async {
        QuoteProvider quoteProvider =
            await setupQuoteProvider(TestUserIds.dealer, 'dealer');

        expect(quoteProvider.transaction.cryptoType, isNotEmpty);
        quoteProvider.changeTransactionField(TransactionProps.quantity, 12.5);
        expect(quoteProvider.transaction.quantity, 12.5);
        expect(
          quoteProvider.transaction.price,
          quoteProvider.transaction.costPrice * 12.5,
        );
      },
    );

    test('Test to send a quote from dealer to customer', () async {
      await (await SharedPreferences.getInstance()).clear();
      QuoteProvider quoteProvider =
          await setupQuoteProvider(TestUserIds.dealer, 'dealer');

      quoteProvider.changeTransactionField(
        TransactionProps.receiver,
        Profile.fromMap(
          const {'phone': '+911234567890', 'customerId': ''},
        ),
      );
      double randomQuantity =
          Random().nextInt(100).toDouble() + Random().nextDouble();

      quoteProvider.changeTransactionField(
        TransactionProps.quantity,
        randomQuantity,
      );
      assert(quoteProvider.transaction.quantity == randomQuantity);
      final success = await quoteProvider.sendQuote();
      expect(success, true);
    });
    test('Test to send a quote from customer to dealer', () async {
      await (await SharedPreferences.getInstance()).clear();
      QuoteProvider quoteProvider =
          await setupQuoteProvider(TestUserIds.customer, UserTypes.customer);

      quoteProvider.changeTransactionField(
        TransactionProps.receiver,
        Profile.fromMap(
          const {'phone': '+919999999999', },
        ),
      );
      double randomQuantity =
          Random().nextInt(100).toDouble() + Random().nextDouble();

      quoteProvider.changeTransactionField(
        TransactionProps.quantity,
        randomQuantity,
      );
      assert(quoteProvider.transaction.quantity == randomQuantity);
      final success = await quoteProvider.sendQuote();
      expect(success, true);
    });
  });
}
