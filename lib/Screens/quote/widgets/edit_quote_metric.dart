import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/margin_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget to edit either Quantity or Amount
class EditQuoteMetric extends StatelessWidget {
  const EditQuoteMetric({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: newline-before-return
    return Consumer<QuoteProvider>(
      builder: (_, quoteProvider, __) => Consumer<ProfileChangeNotifier>(
            builder: (__,profileNotifier,pp) {
              var userType = profileNotifier.profile.userType;

          return Column(
            children: [
              Text(
                quoteProvider.quoteMode == QuoteMode.Quantity
                    ? 'Amount'
                    : 'Quantity',
                style: const TextStyle(
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
                      color: userType == UserTypes.customer
                                        ? Color(0xffE47331)
                                        : Color(0xff70755F),
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: TextFormField(
                      initialValue: quoteProvider.quoteMode == QuoteMode.Quantity
                          ? quoteProvider.transaction.price.toStringAsFixed(2)
                          : quoteProvider.transaction.quantity.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: (string) {
                        double? q = double.tryParse(string);
                        if (q != null) {
                          if (quoteProvider
                                  .profileChangeNotifier.profile.userType ==
                              UserTypes.customer) {
                            if (quoteProvider.quoteMode == QuoteMode.Quantity) {
                              return;
                            }
                          }
                          quoteProvider.changeTransactionField(
                            quoteProvider.quoteMode == QuoteMode.Quantity
                                ? TransactionProps.price
                                : TransactionProps.quantity,
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
          );
        },
      ),
    );
  }
}
