import 'package:cvault/constants/theme.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:flutter/material.dart';
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
    return Consumer<QuoteProvider>(
      builder: (_, quoteProvider, __) => Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromARGB(255, 165, 231, 243),
          ),
        ),
        child: Consumer<HomeStateNotifier>(
          builder: (_, homeNotifier, __) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isPriceSelected
                  ? Text(
                      (homeNotifier.state.isUSD ? '\$' : '₹') +
                          quoteProvider.transaction.price.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      "${quoteProvider.transaction.cryptoType.toUpperCase()} ${quoteProvider.transaction.quantity}",
                      style: const TextStyle(
                        color: Colors.white,
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
                      child: ElevatedButton(
                        onPressed: () async {
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

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          elevation: 10,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Send Quote",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
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
                      color: const Color.fromARGB(255, 165, 231, 243),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    inputFormatters: const [],
                    onChanged: (string) {
                      quoteProvider.changeTransactionField(
                        TransactionProps.customer,
                        Profile.fromMap(
                          {'phone': string, 'customerId': ''},
                        ),
                      );
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
          ),
        ),
      ),
    );
  }
}
