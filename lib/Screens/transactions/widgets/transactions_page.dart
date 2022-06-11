import 'package:cvault/Screens/transactions/widgets/transaction_tile.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transaction/transaction.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  Widget _buildTransactionList(List<Transaction> transactions) {
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (BuildContext context, int index) {
        // var transaction = Transaction.mock();
        return TransactionTile(transaction: transactions[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Transactions",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xff1E2224),
      body: Consumer<TransactionsProvider>(
        builder: (context, transactionsProvider, __) {
          switch (transactionsProvider.loadStatus) {
            case LoadStatus.loading:
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff03dac6),
                ),
              );
            case LoadStatus.error:
              return const Center(
                child: Text(
                  "An error has occurred!",
                  style: TextStyle(color: Colors.white),
                ),
              );
            default:
              return _buildTransactionList(
                transactionsProvider.transactions,
              );
          }
        },
      ),
    );
  }
}
