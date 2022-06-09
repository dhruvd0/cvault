import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/models/transaction.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendQuoteBox extends StatelessWidget {
  const SendQuoteBox({
    Key? key,
    required this.price,
  }) : super(key: key);

  final bool price;

  @override
  Widget build(BuildContext context) {
    return Consumer<QuoteProvider>(
      builder: (_, quoteProvider, __) => Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Consumer<HomeStateNotifier>(
          builder: (_, homeNotifier, __) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              price
                  ? Text(
                      (homeNotifier.state.isUSD ? '\$' : '₹') +
                          quoteProvider.transaction.price.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  : Text(
                      "${quoteProvider.transaction.cryptoType.toUpperCase()} ${quoteProvider.transaction.quantity}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              const SizedBox(
                height: 25,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.45,
                child: ElevatedButton(
                  onPressed: () {
                    /// TODO: send quote
                  },
                  child: const Text(
                    "Send Quote",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    elevation: 10,
                    shape: const StadiumBorder(),
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
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  padding: EdgeInsets.all(5),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    autovalidateMode: AutovalidateMode.always,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [],
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
