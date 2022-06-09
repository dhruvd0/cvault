import 'package:cvault/models/transaction.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuySellToggle extends StatelessWidget {
  const BuySellToggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (_, quoteProvider, __) => Column(
        children: [
          const Text(
            "Buy-Sell",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Switch(
            activeColor: Colors.green,
            activeTrackColor: Colors.lightGreen,
            inactiveThumbColor: Colors.grey,
            inactiveTrackColor: Colors.black,
            value: quoteProvider.transaction.transactionType == 'buy'
                ? false
                : true,
            onChanged: (value) {
              quoteProvider.changeTransactionField(
                TransactionProps.transactionType,
                value ? 'sell' : 'buy',
              );
            },
          ),
        ],
      ),
    );
  }
}
