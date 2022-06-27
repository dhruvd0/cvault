import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  test('Test to accept a transaction', () async {
    final profileChangeNotifier =
        await setupProfileProvider(TestUserIds.dealer, 'dealer');
    final transactionsProvider = TransactionsProvider(profileChangeNotifier);
    await transactionsProvider.getTransactions();
    

    final lastTransaction = transactionsProvider.transactions
        .firstWhere((element) => element.receiver.uid == TestUserIds.dealer);

    await transactionsProvider.changeTransactionStatus(
      lastTransaction.id,
      TransactionStatus.accepted,
    );
    transactionsProvider.changePage(1);
    await transactionsProvider.getTransactions();
    expect(
      transactionsProvider.transactions.any(
        (t) =>
            t.id == lastTransaction.id &&
            t.status == TransactionStatus.accepted.name,
      ),
      true,
    );
  });
}
