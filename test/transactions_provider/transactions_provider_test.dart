import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  group('Transactions provider Tests:', () {
    test('Test to fetch all transactions', () async {
      final profileProvider =
          await setupProfileProvider(TestUserIds.admin, 'admin');
      final transactionsProvider = TransactionsProvider(
        profileProvider,
      );

      await transactionsProvider.getTransactions();
      expect(transactionsProvider.transactions, isNotEmpty);
    });
    test('Test to fetch transactions of a dealer', () async {
      final profileProvider =
          await setupProfileProvider(TestUserIds.dealer, 'dealer');
      final transactionsProvider = TransactionsProvider(profileProvider);

      await transactionsProvider.getTransactions(
       
      );
      expect(transactionsProvider.transactions, isNotEmpty);
      expect(
        transactionsProvider.transactions.first.receiver.firstName,
        isNotEmpty,
      );
      
    });
  });
}
