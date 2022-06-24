import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import '../config/mocks.dart';

void main() {
  test('Test to change status of a transaction', () async {
    final profileChangeNotifier =
        await setupProfileProvider(TestUserIds.dealer, 'dealer');
    final transactionsProvider = TransactionsProvider(profileChangeNotifier);
    await transactionsProvider.getDealerTransaction(TestUserIds.dealer);
    if (transactionsProvider.transactions.isEmpty) {
      /// TODO: send test quote
    }
    final lastTransaction = transactionsProvider.transactions.first;
    final randomStatus = 'status-${Uuid().v4()}';
    await transactionsProvider.changeTransactionStatus(
        lastTransaction.id, TransactionStatus.accepted);
    expect(
      transactionsProvider.transactions.any(
        (t) =>
            t.id == lastTransaction.id &&
            t.status == TransactionStatus.accepted,
      ),
      true,
    );
  });
}
