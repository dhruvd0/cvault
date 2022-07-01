import 'dart:developer';

import 'package:cvault/Screens/transactions/widgets/transaction_tile.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  void _onRefresh(context) async {
    var provider = Provider.of<TransactionsProvider>(context, listen: false);
    provider.changePage(1);
    await provider.getTransactions();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.addListener(() {
        if (!_scrollController.hasClients) {
          return;
        }
        // final provider =
        //     Provider.of<TransactionsProvider>(context, listen: false);
        // if (_scrollController.offset ==
        //         _scrollController.position.maxScrollExtent &&
        //     !(provider.loadStatus == LoadStatus.loading)) {
        //   provider.incrementPage();
        //   provider.getTransactions();
        // }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xff1E2224),
      body: RefreshIndicator(
        onRefresh: () async {
          _onRefresh(context);
        },
        child: GestureDetector(
          child: Consumer<ProfileChangeNotifier>(
            builder: (context, profileNotifier, __) {
              switch (profileNotifier.loadStatus) {
                case LoadStatus.error:
                  return const Center(
                    child: Text(
                      "An error has occurred!",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                default:
                  var transactions = profileNotifier.profile.transactions;
                  log(transactions.toString());
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: transactions.isEmpty &&
                                profileNotifier.loadStatus == LoadStatus.loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                itemCount: transactions.length,
                                controller: _scrollController,
                                itemBuilder: (BuildContext context, int index) {
                                  // var transaction = Transaction.mock();
                                  return TransactionTile(
                                    transaction: transactions[index],
                                  );
                                },
                              ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      profileNotifier.loadStatus == LoadStatus.loading &&
                              transactions.isNotEmpty
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ThemeColors.lightGreenAccentColor,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
