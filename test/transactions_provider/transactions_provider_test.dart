import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  group('Transactions provider Tests:', () {
    test('Test to fetch all transactions', () async {
      final transactionsProvider = TransactionsProvider(
        (await ProfileChangeNotifier(mockAuth)
          ..fetchProfile()),
      );

      await transactionsProvider.getAllTransactions();
      expect(transactionsProvider.transactions, isNotEmpty);
    });
  });
}
