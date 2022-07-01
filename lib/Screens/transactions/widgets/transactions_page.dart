import 'package:cvault/Screens/transactions/widgets/transaction_tile.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ListView to see all transactions
class TransactionsPage extends StatefulWidget {
  ///
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
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
        final provider =
            Provider.of<TransactionsProvider>(context, listen: false);
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            !(provider.loadStatus == LoadStatus.loading)) {
          provider.incrementPage();
          provider.getTransactions();
        }
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
          "Transactions",
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
        child: Consumer<TransactionsProvider>(
          builder: (context, transactionsProvider, __) {
            switch (transactionsProvider.loadStatus) {
              case LoadStatus.error:
                return const Center(
                  child: Text(
                    "An error has occurred!",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              default:
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: transactionsProvider.transactions.isEmpty &&
                              transactionsProvider.loadStatus ==
                                  LoadStatus.loading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : GestureDetector(
                              onTap: () {
                                transactionsProvider.Expand();
                              },
                              child: ListView.builder(
                                itemCount:
                                    transactionsProvider.transactions.length,
                                controller: _scrollController,
                                itemBuilder: (BuildContext context, int index) {
                                  // var transaction = Transaction.mock();
                                  return TransactionTile(
                                    transaction: transactionsProvider
                                        .transactions[index],
                                  );
                                },
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    transactionsProvider.loadStatus == LoadStatus.loading &&
                            transactionsProvider.transactions.isNotEmpty
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
    );
  }
}
