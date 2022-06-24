import 'package:cvault/Screens/transactions/widgets/transaction_tile.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/transaction/transaction.dart';

/// ListView to see all transactions
class TransactionsPage extends StatelessWidget {
  ///
  TransactionsPage({Key? key}) : super(key: key);
  final ScrollController _scrollController = ScrollController();
  Widget _buildTransactionList(
    List<Transaction> transactions,
    BuildContext context,
  ) {
    var provider = Provider.of<TransactionsProvider>(context, listen: false);

    return ListView.builder(
      itemCount: transactions.length,
      controller: _scrollController
        ..addListener(() {
          if (_scrollController.offset ==
                  _scrollController.position.maxScrollExtent &&
              !(provider.loadStatus == LoadStatus.loading)) {
            provider.incrementPage();
            provider.getTransactions();
          }
        }),
      itemBuilder: (BuildContext context, int index) {
        // var transaction = Transaction.mock();
        return TransactionTile(transaction: transactions[index]);
      },
    );
  }

  void _onRefresh(context) async {
    var provider = Provider.of<TransactionsProvider>(context, listen: false);
    provider.changePage(1);
    await provider.getTransactions();
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
      body: RefreshIndicator(
        onRefresh: () async {
          _onRefresh(context);
        },
        child: GestureDetector(
          child: Consumer<TransactionsProvider>(
            builder: (context, transactionsProvider, __) {
              switch (transactionsProvider.loadStatus) {
                case LoadStatus.error:
                  return const Center(
                    child: Text(
                      "An error has occurred!",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                default:
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: _buildTransactionList(
                          transactionsProvider.transactions,
                          context,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      transactionsProvider.loadStatus == LoadStatus.loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ThemeColors.lightGreenAccentColor,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
