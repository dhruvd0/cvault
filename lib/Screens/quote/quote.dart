import 'package:cvault/Screens/quote/widgets/margins_percentage_field.dart';
import 'package:cvault/Screens/settings/settting.dart';
import 'package:cvault/Screens/quote/widgets/buy_sell_toggle.dart';
import 'package:cvault/Screens/quote/widgets/edit_quote_metric.dart';
import 'package:cvault/Screens/quote/widgets/send_quote_box.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/home_state.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:cvault/widgets/usd_inr_toggle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../drawer.dart';

class Quote extends StatefulWidget {
  const Quote({Key? key}) : super(key: key);

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('##,##,###');
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    // ignore: newline-before-return
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const MyDrawer(),
      backgroundColor: const Color(0xff1F1D2B),
      appBar: AppBar(
        leading: const SizedBox(),
        
        centerTitle: true,
        title: const Text("Quote"),
        backgroundColor: Color(0xff252836),
        actions: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: const Icon(Icons.menu),
            color: Colors.white,
            iconSize: 30,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          key: UniqueKey(),
          child: Consumer<HomeStateNotifier>(
            builder: (context, homeStateNotifier, _) {
              final state = homeStateNotifier.state;
              if (state.loadStatus == LoadStatus.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ThemeColors.lightGreenAccentColor,
                  ),
                );
              }

              return state.loadStatus == LoadStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<QuoteProvider>(
                      builder: (context, quoteProvider, __) {
                        return Consumer<ProfileChangeNotifier>(
                          builder: (kk,profileNotifier,__)
                          
                          {
                            var userType = profileNotifier.profile.userType;

                            return Container(
                              margin: const EdgeInsets.only(top:20,left: 20,right: 20),
                              padding:const EdgeInsets.only(top:30,left: 20,right: 20,bottom: 30),
                              
                              
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                              
                              color: const Color(0xff252836),),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.80,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                              color:   userType ==UserTypes.customer? const Color(0xffE47331):Color(0xff566749),
                                      ),
                            
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              quoteProvider
                                                  .changeQuoteMode(QuoteMode.Price);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30,
                                              margin: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                                               color: quoteProvider.quoteMode ==
                                                      QuoteMode.Price
                                                  ?
                                                                               Colors.white:userType ==UserTypes.customer? const Color(0xffE47331):Color(0xff566749),
                                              ),
             
                                              child: Center(
                                                child: Text(
                                                  "Price",
                                                  style: TextStyle(
                                                    color:
                                                        quoteProvider.quoteMode ==
                                                                QuoteMode.Price
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              quoteProvider.changeQuoteMode(
                                                QuoteMode.Quantity
                                              );
                                              print(quoteProvider.quoteMode);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15),
                                                  color: quoteProvider.quoteMode ==
                                                      QuoteMode.Quantity
                                                  ?
                                                  Colors.white:userType ==UserTypes.customer? const Color(0xffE47331):const Color(0xff566749),
                                              ),
                                          
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30,
                                              margin: const EdgeInsets.all(5),
                                              child: Center(
                                                child: Text(
                                                  "Quantity",
                                                  style: TextStyle(
                                                    color:
                                                        quoteProvider.quoteMode ==
                                                                QuoteMode.Quantity
                                                            ? Colors.black
                                                            : Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Settings(),
                                            ),
                                          );
                                        },
                                        child: Consumer<HomeStateNotifier>(
                                          builder: (context, notifier, _) {
                                            return Row(
                                              children: [
                                                Container(
                                                      width: 100,
                                                      padding:const EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          15,
                                                        ),
                                                        color: userType == UserTypes.customer?const Color.fromARGB(255, 239, 179, 89):Color(0xff566749),
                                                      ),
                                                      child: Center(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '${state.selectedCurrencyKey.toUpperCase()}',
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors.white,
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight.w600,
                                                              ),
                                                            ),
                                                            const Icon(
                                                              Icons
                                                                  .arrow_drop_down_rounded,
                                                              color: Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),    ],
                                            );
                                          },
                                        ),
                                      ),
                                      const USDToINRToggle(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Cost Price",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Consumer<QuoteProvider>(
                                            builder: (context, quoteProvider, __) {
                                              return Flexible(
                                                child: Center(
                                                  child: homeStateNotifier.state
                                                          is HomeInitial
                                                      ? const Text("Loading")
                                                      : Text(
                                                          state.cryptoCurrencies
                                                                  .isEmpty
                                                              ? ''
                                                              : '${homeStateNotifier.state.isUSD ? '\$' : '₹'}${formatter.format(quoteProvider.transaction.costPrice.toInt())}'
                                                                  .replaceAll(
                                                                  ',',
                                                                  ',',
                                                                ),
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      const BuySellToggle(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:const [
                                      MarginPercentageField(),
                                      EditQuoteMetric(),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SendQuoteBox(
                                    isPriceSelected:
                                        quoteProvider.quoteMode == QuoteMode.Price,
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
            },
          ),
        ),
      ),
    );
  }
}
