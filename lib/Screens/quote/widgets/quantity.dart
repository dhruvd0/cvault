import 'package:cvault/models/transaction.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Quantity extends StatelessWidget {
  const Quantity({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (_, quoteProvider, __) => Column(
        children: [
          const Text(
            "Quantity",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            height: 50,
            width: 120,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  width: 1.5,
                  color: Color.fromARGB(255, 165, 231, 243),
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: TextFormField(
                  initialValue: quoteProvider.transaction.quantity.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  onChanged: (string) {
                    double? q = double.tryParse(string);
                    if (q != null) {
                      quoteProvider.changeTransactionField(
                        TransactionProps.quantity,
                        q,
                      );
                    }
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
