import 'package:cvault/Screens/transactions/widgets/transaction_tile.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transaction.dart';

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
    final transactionsProvider = Provider.of<TransactionsProvider>(context);
    final profileProvider = Provider.of<ProfileChangeNotifier>(context);
    String? dealerId;

    if (profileProvider.profile.userType == UserTypes.dealer) {
      dealerId = profileProvider.profile.uid;
    }

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
      body: (transactionsProvider.isLoadedTransactions(
        retriever: dealerId ?? "admin",
      ))
          ? _buildTransactionList(transactionsProvider.transactions)
          : FutureBuilder(
              future: (dealerId == null)
                  ? Provider.of<TransactionsProvider>(context, listen: false)
                      .getDealerTransaction("1234")
                  : Provider.of<TransactionsProvider>(context, listen: false)
                      .getDealerTransaction(dealerId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(
                        color: const Color(0xff03dac6),
                      ),
                    );
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          "An error has occurred!",
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    return _buildTransactionList(
                      transactionsProvider.transactions,
                    );
                }
              },
            ),
    );
  }
}
