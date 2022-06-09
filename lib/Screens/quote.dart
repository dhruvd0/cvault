import 'dart:ui';

import 'package:cvault/Screens/Setting.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../drawer.dart';

class Quote extends StatefulWidget {
  const Quote({Key? key}) : super(key: key);

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  bool price = true;
  bool toggle = false;
  bool buy = true;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      endDrawer: const MyDrawer(),
      backgroundColor: const Color(0xff1E2224),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
          // ignore: newline-before-return
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "USD-INR",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Switch(
                                autofocus: true,
                                activeColor: Colors.white,
                                activeTrackColor: Colors.lightGreen,
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.black,
                                value: toggle,
                                onChanged: (value) {
                                  setState(() {
                                    toggle = value;
                                  });
                                  Provider.of<HomeStateNotifier>(
                                    context,
                                    listen: false,
                                  ).toggleIsUSD(!value);
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
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Cost Price",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Flexible(
                                child: Center(
                                  child: Text(
                                    state.cryptoCurrencies.isEmpty
                                        ? ''
                                        : (state.isUSD
                                            ? '\$${homeStateNotifier.currentCryptoCurrency().krakenPrice.toStringAsFixed(2)}'
                                            : buy
                                                ? '₹${homeStateNotifier.currentCryptoCurrency().wazirxPrice.toStringAsFixed(2)}'
                                                : '₹${homeStateNotifier.currentCryptoCurrency().sellPrice.toStringAsFixed(2)}'),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "Buy-Sell",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Switch(
                                activeColor: Colors.green,
                                activeTrackColor: Colors.lightGreen,
                                inactiveThumbColor: Colors.grey,
                                inactiveTrackColor: Colors.black,
                                value: buy,
                                onChanged: (value) {
                                  setState(() {
                                    buy = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
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
                                  fontSize: 20,
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
                          Column(
                            children: [
                              const Text(
                                "Quantity",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
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
                                      color: Colors.white30,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '20.0',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            price
                                ? const Text(
                                    "25,33,118.00",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                : const Text(
                                    "BTC 0.3211214",
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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
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
                    ]),
                  ),
                );
        },
      ),
    );
  }
}
