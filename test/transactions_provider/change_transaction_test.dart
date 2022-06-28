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

    final transactionWhereReceiverIsDealer = transactionsProvider.transactions
        .firstWhere((element) => element.receiver.uid == TestUserIds.dealer);

    await transactionsProvider.changeTransactionStatus(
      transactionWhereReceiverIsDealer.id,
      TransactionStatus.accepted,
    );
    transactionsProvider.changePage(1);
    await transactionsProvider.getTransactions();
    expect(
      transactionsProvider.transactions.any(
        (t) =>
            t.id == transactionWhereReceiverIsDealer.id &&
            t.status == TransactionStatus.accepted.name,
      ),
      true,
    );
  });

  test('Test to reject a transaction', () async {
    final profileChangeNotifier =
        await setupProfileProvider(TestUserIds.dealer, 'dealer');
    final transactionsProvider = TransactionsProvider(profileChangeNotifier);
    await transactionsProvider.getTransactions();

    final transactionWhereReceiverIsDealer = transactionsProvider.transactions
        .firstWhere((element) => element.receiver.uid == TestUserIds.dealer);

    await transactionsProvider.deleteTransaction(
      transactionWhereReceiverIsDealer.id,
    );
    transactionsProvider.changePage(1);
    await transactionsProvider.getTransactions();
    expect(
      transactionsProvider.transactions.any(
        (t) => t.id == transactionWhereReceiverIsDealer.id,
      ),
      false,
    );
  });
}
