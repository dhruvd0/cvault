import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
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
          const Text.rich(
  TextSpan(
    children: [
      TextSpan(text: 'Buy',style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xff35E065),
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),),
      TextSpan(
        text: '-',
        style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
      ),
      TextSpan(text: 'Sell',style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xffEA4B63),
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),),
    ],
  ),),
  const SizedBox(
              height: 10,
            ),
         
          Consumer<QuoteProvider>(
      builder: (_, quoteProvider, __){
              return FlutterSwitch(
                  activeColor: Colors.white,
                  inactiveColor: Colors.transparent,
                  activeToggleColor:const Color(0xffEA4B63),
                  inactiveToggleColor: Color(0xff35E065),
                  switchBorder: Border.all(
                            color: Colors.white,
                            //width: 1.0,
                          ),
                          toggleBorder: Border.all(
                            color: Colors.transparent,
                            //width: 3.0,
                          ),
                width: 70.0,
                height: 30.0,
                
                toggleSize: 45.0,
                value: quoteProvider.transaction.transactionType == 'buy'
                ? false
                : true,
                borderRadius: 30.0,
               
                
                onToggle: (value) {
                  
                    quoteProvider.changeTransactionField(
                TransactionProps.transactionType,
                value ? 'sell' : 'buy',
              );
                  
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
