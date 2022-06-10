import 'package:cvault/Screens/Setting.dart';
import 'package:cvault/Screens/quote/widgets/quantity.dart';
import 'package:cvault/Screens/quote/widgets/send_quote_box.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/models/home_state.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/widgets/usd_inr_toggle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../drawer.dart';

class Quote extends StatefulWidget {
  const Quote({Key? key}) : super(key: key);

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  bool price = true;
  bool sell = false;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const MyDrawer(),
      backgroundColor: const Color(0xff1E2224),
      appBar: AppBar(
        leading: SizedBox(),
        centerTitle: true,
        title: const Text("Quote"),
        backgroundColor: Colors.transparent,
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
      body: Consumer<HomeStateNotifier>(
        builder: (context, homeStateNotifier, _) {
          final state = homeStateNotifier.state;
          if (state.loadStatus == LoadStatus.loading) {
            return Center(
              child: CircularProgressIndicator(
                color: ThemeColors.lightGreenAccentColor,
              ),
            );
          }

          return state.loadStatus == LoadStatus.loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    color: Colors.transparent,
                    child: Column(children: [
                      SizedBox(
                        height: 50,
                        child: Container(
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    price = true;
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  margin: const EdgeInsets.all(5),
                                  color: price ? Colors.white : Colors.black,
                                  child: Center(
                                    child: Text(
                                      "Price",
                                      style: TextStyle(
                                        color:
                                            price ? Colors.black : Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    price = false;
                                  });
                                },
                                child: Container(
                                  color: !price ? Colors.white : Colors.black,
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  margin: const EdgeInsets.all(5),
                                  child: Center(
                                    child: Text(
                                      "Quantity",
                                      style: TextStyle(
                                        color: !price
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Settings(),
                                ),
                              );
                            },
                            child: Consumer<HomeStateNotifier>(
                              builder: (context, notifier, _) {
                                return Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.blue,
                                      backgroundImage: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoG97VgQYJGXN8kDJkOMvh79mgLvO5iEfVWA&usqp=CAU",
                                      ),
                                    ),
                                    Text(
                                      notifier.state.selectedCurrencyKey
                                          .toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          USDToINRToggle(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Cost Price",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Flexible(
                                child: Center(
                                  child: homeStateNotifier.state is HomeInitial
                                      ? const Text("Loading")
                                      : Text(
                                          state.cryptoCurrencies.isEmpty
                                              ? ''
                                              : (state.isUSD
                                                  ? '\$${homeStateNotifier.currentCryptoCurrency().krakenPrice.toStringAsFixed(2)}'
                                                  : sell
                                                      ? '₹${homeStateNotifier.currentCryptoCurrency().wazirxPrice.toStringAsFixed(2)}'
                                                      : "₹${homeStateNotifier.currentCryptoCurrency().sellPrice.toStringAsFixed(2)}"),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          // BuySellToggle(),
                          Column(
                            children: [
                              Text(
                                "Buy-Sell",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Switch(
                                activeColor: Colors.white,
                                activeTrackColor: Colors.lightGreen,
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.black,
                                value: sell,
                                onChanged: (value) {
                                  setState(() {
                                    sell ? false : true;
                                    sell = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Margin (%)",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              InkWell(
                                onTap: () {
                                  /// TODO: change margin
                                },
                                child: SizedBox(
                                  height: 50,
                                  width: 120,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        width: 1.5,
                                        color: Colors.white30,
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '5.00%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Quantity(),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SendQuoteBox(price: price),
                    ]),
                  ),
                );
        },
      ),
    );
  }
}
