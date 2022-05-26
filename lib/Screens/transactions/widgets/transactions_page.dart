import 'package:cvault/Screens/transactions/models/transaction.dart';
import 'package:cvault/Screens/transactions/widgets/transaction_tile.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

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
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          var transaction = Transaction.mock();

          return TransactionTile(transaction: transaction);
        },
      ),
    );
  }
}
