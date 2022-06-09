import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  group('Quote Provider Tests', () {
    test(
      'Test to change quote quantity',
      () async {
        QuoteProvider quoteProvider = await _setupQuoteProvider();

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
     QuoteProvider quoteProvider = await _setupQuoteProvider();


      quoteProvider.changeTransactionField(
        TransactionProps.customer,
        Profile.fromMap(
          {'phone': mockAuth.currentUser!.phoneNumber, 'customerId': ''},
        ),
      );
      quoteProvider.changeTransactionField(TransactionProps.quantity, 12.5);
      await quoteProvider.sendQuote();
    });
  });
}

Future<QuoteProvider> _setupQuoteProvider() async {
   HomeStateNotifier homeStateNotifier = HomeStateNotifier(mockAuth);
  ProfileChangeNotifier profileChangeNotifier =
      ProfileChangeNotifier(mockAuth);
  await Future.wait([
    homeStateNotifier.getCryptoDataFromAPIs(),
    profileChangeNotifier.fetchProfile(),
  ]);
  
  final quoteProvider = QuoteProvider(
    homeStateNotifier,
    profileChangeNotifier,
  );
  quoteProvider.updateWithHomeNotifierState();
  quoteProvider.updateWithProfileProviderState();
  
  return quoteProvider;
}
