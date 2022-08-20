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
    var formatter = NumberFormat('#,###');
    final myController = TextEditingController();


    return Consumer<QuoteProvider>(
      builder: (_, quoteProvider, __) => Consumer<ProfileChangeNotifier>(
        builder: (kk,profileNotifier,ss) {
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
                  

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      isPriceSelected
                          ? Consumer<TransactionsProvider>(
                              builder: (s, context, u) {
                                return Text(
                                  (homeNotifier.state.isUSD ? '\$' : '₹') +
                                      //quoteProvider.transaction.price.toString(),
                                      "${formatter.format(quoteProvider.transaction.price + (quoteProvider.transaction.price / 100) * context.NewMArgin.toInt())}"
                                          .replaceAll(',', ','),
                                  style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              },
                            )
                          : Text(
                              "${quoteProvider.transaction.cryptoType.toUpperCase()} ${quoteProvider.transaction.quantity.toStringAsFixed(8)}",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
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
                          : SizedBox(
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Consumer<ProfileChangeNotifier>(
              builder: (context, profileNotifier, _) {
                var userType = profileNotifier.profile.userType;
                
                                  return ElevatedButton(
                                    onPressed: () async {
                                      print(quoteProvider.phoneNumber);
                                      final success = await quoteProvider.sendQuote();

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
                                      quoteProvider.SendNotifiaction(quoteProvider.phoneNumber).then(
                                          (value) => ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar),);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary:userType == UserTypes.customer
                                              ? Color(0xffE47331)
                                              : Color(0xff566749),
                                      elevation: 10,
                                      shape: const StadiumBorder(),
                                    ),
                                    child: const Text(
                                      "Send Quote",
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                            inputFormatters: const [],
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
