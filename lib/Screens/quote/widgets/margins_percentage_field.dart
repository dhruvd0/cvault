import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/transaction/transaction.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/providers/margin_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MarginPercentageField extends StatelessWidget {
  const MarginPercentageField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (q, profileNotifier, k) {
        var userType = profileNotifier.profile.userType;
        // ignore: newline-before-return
        return Consumer<QuoteProvider>(
          builder: (j, quoteProvider, n) {
            
            
            return userType == UserTypes.customer
                ? Container()
                : Column(
                    children: [
                      const Text(
                        "Margin %",
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
                              color: userType == UserTypes.customer
                                        ? Color(0xffE47331)
                                        : Color(0xff70755F),
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Consumer<TransactionsProvider>(
                            builder: (s, context, u) {
                              return TextFormField(
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                keyboardType:const TextInputType.numberWithOptions(
                                    decimal: true,),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                                onChanged: (string) {
                                  if(double.parse(string)>=0){context.NewMArgin = double.parse(string);
                          quoteProvider.finalMargin= double.parse(string);}else{
                            context.NewMArgin = 0.0;
                          quoteProvider.finalMargin= 0.0;
                            
                          }
                                  
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
          },
        );
      },
    );
  }
}
