import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/transaction/transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({Key? key, required this.transaction})
      : super(key: key);

  final Transaction transaction;

  bool isUserAReceiverDealer(ProfileChangeNotifier profileProvider) {
    return transaction.status == 'accepted' || transaction.status == 'rejected'
        ? false
        : profileProvider.profile.userType == 'admin'
            ? true
            : profileProvider.profile.userType == UserTypes.customer ||
                    transaction.status != 'sent'
                ? false
                : transaction.receiver.uid ==
                    FirebaseAuth.instance.currentUser!.uid;
  }

  Widget expansionTileContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width / 3,
                    ),
                    child: Text(
                      transaction.receiver.firstName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    (transaction.currency == 'usdt' ? '\$' : '₹') +
                        transaction.price.toStringAsFixed(2),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TransactionStatusWidget(transaction: transaction),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat(DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                        .format(DateTime.parse(transaction.createdAt)),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  List<Widget> _tileButtons(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProfileChangeNotifier>(
          builder: (_, profileProvider, __) => Row(
            children: [
              Expanded(child: Container()),
              GestureDetector(
                onTap: () {
                  Provider.of<TransactionsProvider>(
                    context,
                    listen: false,
                  ).changeTransactionStatus(
                    transaction.id,
                    TransactionStatus.accepted,
                    context,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: const Text('Accept'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () async {
                  var of = Provider.of<TransactionsProvider>(
                    context,
                    listen: false,
                  );
                  await of.changeTransactionStatus(
                    transaction.id,
                    TransactionStatus.rejected,
                    context,
                  );
                  of.deleteTransaction(transaction.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.red,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Consumer<ProfileChangeNotifier>(
        builder: (_, profileProvider, __) =>
            !isUserAReceiverDealer(profileProvider)
                ? expansionTileContent(context)
                : ExpansionTile(
                    iconColor: Colors.white,
                    collapsedIconColor: Colors.white,
                    initiallyExpanded: isUserAReceiverDealer(profileProvider),
                    title: expansionTileContent(context),
                    children: isUserAReceiverDealer(profileProvider)
                        ? _tileButtons(context)
                        : [],
                  ),
      ),
    );
  }
}

class TransactionStatusWidget extends StatelessWidget {
  const TransactionStatusWidget({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final Transaction transaction;

  String get getStatus {
    return transaction.status == 'sent'
        ? transaction.receiver.uid == FirebaseAuth.instance.currentUser!.uid
            ? 'Received'
            : 'Sent'
        : transaction.status;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getStatus,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: getStatus == 'rejected'
            ? Colors.red
            : getStatus == 'Sent'
                ? Colors.blue
                : getStatus == 'Received'
                    ? Colors.yellow
                    : Colors.green,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
