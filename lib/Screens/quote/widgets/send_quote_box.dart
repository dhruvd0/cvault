import 'package:cvault/constants/theme.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/NotificationApiProvider.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart';

/// Has phone number text field, send quote button
class SendQuoteBox extends StatelessWidget {
  ///
  const SendQuoteBox({
    Key? key,
    required this.isPriceSelected,
  }) : super(key: key);

  /// If [true] then switch to Price mode else Quantity Mode
  final bool isPriceSelected;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('##,##,###');
    final myController = TextEditingController();

    return Consumer<QuoteProvider>(
      builder: (_, quoteProvider, __) => Consumer<ProfileChangeNotifier>(
        builder: (kk, profileNotifier, ss) {
          var userType = profileNotifier.profile.userType;

          return Container(
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: userType == UserTypes.customer
                    ? Color(0xffE47331)
                    : Color(0xff566749),
              ),
            ),
            child: Consumer<HomeStateNotifier>(
              builder: (_, homeNotifier, __) => Consumer<NotificationProvider>(
                builder: (ss, notifiaction, k) {
                  var quantity = quoteProvider.transaction.costPrice +
                      (quoteProvider.transaction.costPrice / 100) *
                          quoteProvider.finalMargin;
                  var finalQuantity =
                      quoteProvider.transaction.price / quantity;

                  var sellQuantity = quoteProvider.transaction.costPrice -
                      (quoteProvider.transaction.costPrice / 100) *
                          quoteProvider.finalMargin;

                  var sellFinalQunatity =
                      quoteProvider.transaction.price / sellQuantity;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isPriceSelected
                          ? Consumer<TransactionsProvider>(
                              builder: (s, context, u) {
                                return Text(
                                  quoteProvider.transaction.transactionType ==
                                          "sell"
                                      ? (homeNotifier.state.isUSD
                                              ? '\$'
                                              : '₹') +
                                          "${formatter.format(quoteProvider.transaction.price - (quoteProvider.transaction.price / 100) * context.NewMArgin.toInt())}"
                                              .replaceAll(',', ',')
                                      : "${formatter.format(quoteProvider.transaction.price + (quoteProvider.transaction.price / 100) * context.NewMArgin.toInt())}"
                                          .replaceAll(',', ','),
                                  style: TextStyle(
                                    color: quoteProvider
                                                .transaction.transactionType ==
                                            "sell"
                                        ? Colors.yellow
                                        : Colors.green,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            )
                          : RichText(
                              text: TextSpan(
                                text:
                                    "${quoteProvider.transaction.cryptoType.toUpperCase()}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: [
                                  TextSpan(
                                    text: quoteProvider.transaction.status ==
                                            "sell"
                                        ? sellFinalQunatity.toStringAsFixed(8)
                                        : finalQuantity.toStringAsFixed(8),
                                  ),
                                ],
                              ),
                            ),
                      const SizedBox(
                        height: 25,
                      ),
                      quoteProvider.loadStatus == LoadStatus.loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ThemeColors.lightGreenAccentColor,
                              ),
                            )
                          : Consumer<TransactionsProvider>(
                              builder: (s, contexts, u) {
                                return GestureDetector(
                                  onTap: () async {
                                    print(quoteProvider.phoneNumber);
                                    final success =
                                        await quoteProvider.sendQuote(context);

                                    var snackBarText = '';

                                    if (success == null) {
                                      snackBarText = "Something Went Wrong";
                                    } else if (success) {
                                      snackBarText = 'Quote Sent';
                                    } else {
                                      snackBarText = 'This User does not exist';
                                    }

                                    var snackBar = SnackBar(
                                      content: Text(
                                        snackBarText,
                                      ),
                                    );
                                    // ScaffoldMessenger.of(context)
                                    //     .showSnackBar(snackBar);
                                    quoteProvider.SendNotifiaction().then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar),
                                    );
                                    print(quoteProvider.transaction.quantity
                                            .toString() +
                                        "hey");
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: userType == UserTypes.customer
                                          ? Color(0xffE47331)
                                          : Color(0xff566749),
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          blurRadius: 1,
                                          spreadRadius: 2,
                                          offset: const Offset(3, 4),
                                        ),
                                      ],
                                    ),
                                    child: Consumer<ProfileChangeNotifier>(
                                      builder: (context, profileNotifier, _) {
                                        var userType =
                                            profileNotifier.profile.userType;

                                        return const Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            20,
                                            5,
                                            20,
                                            5,
                                          ),
                                          child: Text(
                                            "Send Quote",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                      const SizedBox(height: 10),
                      const Text(
                        "To",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: userType == UserTypes.customer
                                  ? Color(0xffE47331)
                                  : Color(0xff566749),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.all(5),
                          child: TextField(
                            //controller: myController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            //autovalidateMode: AutovalidateMode.always,
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],

                            onChanged: (string) {
                              quoteProvider.changeTransactionField(
                                TransactionProps.receiver,
                                Profile.fromMap(
                                  {'phone': '+91$string', 'customerId': 'hey'},
                                ),
                              );
                              quoteProvider.phoneNumber = "+91$string";
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mobile Number',
                              hintStyle: TextStyle(
                                color: Colors.white54,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
