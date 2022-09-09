import 'package:cvault/providers/NotificationApiProvider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/transactions_provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ScrollController _scrollController = ScrollController();

  List transactions = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMytrans();
  }

  getMytrans() async {
    final data = Provider.of<NotificationProvider>(context, listen: false);

    final tokens =
        Provider.of<ProfileChangeNotifier>(context, listen: false).token;

    transactions = await data.getAllNotification(tokens);
  }

  // void _onRefresh(context) async {
  //   getMytrans();
  // }

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<ProfileChangeNotifier>(context)
        .authInstance
        .currentUser!
        .uid;
    final tokens =
        Provider.of<ProfileChangeNotifier>(context, listen: false).token;

    void _onRefresh() async {
      getMytrans();
    }

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
          _onRefresh();
        },
        child: Consumer<NotificationProvider>(
          builder: (kk, contexts, ll) {
            return transactions.isNotEmpty
                ? ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return _notificationTile(context, index, tokens);
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffE47331),
                    ),
                  );
          },
        ),
      ),
    );
  }

  // ignore: long-method
  Widget _notificationTile(BuildContext context, index, token) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Consumer<NotificationProvider>(
        builder: (ss, contexts, k) {
          return transactions[index]["transactionId"] != null
              ? Container(
                  decoration: BoxDecoration(
                    color: transactions[index]["transactionId"]["status"] ==
                            "accepted"
                        ? Color(0xff35E065)
                        : transactions[index]["transactionId"]
                                    ["transactionType"] ==
                                "buy"
                            ? Color(0xff4895EF)
                            : transactions[index]["transactionId"]
                                        ["transactionType"] ==
                                    "sell"
                                ? Color(0xffFFD44F)
                                : Color(0xff),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: ExpansionTile(
                      iconColor: Colors.white,
                      collapsedIconColor: Colors.white,
                      backgroundColor: transactions[index]["transactionId"]
                                  ["status"] ==
                              "Reject"
                          ? Color(0xffEA4B63)
                          : transactions[index]["transactionId"]!["status"] ==
                                  "Accept"
                              ? Color(0xff35E065)
                              : transactions[index]["transactionId"]
                                          ["Transactiontype"] ==
                                      "buy"
                                  ? Color(0xff4895EF)
                                  : transactions[index]["transactionId"]![
                                              "Transactiontype"] ==
                                          "sell"
                                      ? Color(0xffFFD44F)
                                      : Color(0xff),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            transactions[index]["notifiedTo"]["firstName"] +
                                " " +
                                transactions[index]["notifiedTo"]["lastName"],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            FirebaseAuth.instance.currentUser?.phoneNumber ==
                                    transactions[index]["sentFrom"]["phone"]
                                ? transactions[index]["transactionId"]["status"]
                                : transactions[index]["transactionId"]
                                            ["status"] ==
                                        "sent"
                                    ? "Recieved"
                                    : transactions[index]["transactionId"]
                                        ["status"],
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transactions[index]["transactionId"]["price"]
                                  .toStringAsFixed(2),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            Text(
                              DateFormat('yyyy-MM-dd \nH:m:s').format(
                                  DateTime.parse(transactions[index]
                                          ["transactionId"]["createdAt"])
                                      .toLocal()),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Price",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Text(
                                    transactions[index]["transactionId"]
                                        ["transactionType"],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  const Text(
                                    "Currency",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      transactions[index]["transactionId"]
                                              ["price"]
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                    Text(
                                      transactions[index]["transactionId"]
                                              ["cryptoType"] +
                                          ":" +
                                          " " +
                                          transactions[index]["transactionId"]
                                                  ["quantity"]
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                child: FirebaseAuth.instance.currentUser
                                            ?.phoneNumber !=
                                        transactions[index]["sentFrom"]["phone"]
                                    ? transactions[index]["transactionId"]
                                                ["status"] ==
                                            "sent"
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary:
                                                      const Color(0xff35E065),
                                                ),
                                                onPressed: () async {
                                                  contexts.updateNotifiaction(
                                                    token,
                                                    //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzA3NTU5ZGFkNTFjZmQyMTRmMjExZDEiLCJpYXQiOjE2NjE0MjcxNjl9.qq6K1rDy_F7XEHUA7_35mk4FgCRqYjaFqVj9is7ipN4",
                                                    transactions[index]
                                                            ["transactionId"]
                                                        ["_id"],
                                                  );
                                                  print(token);
                                                  print(
                                                    transactions[index]
                                                            ["transactionId"]
                                                        ["_id"],
                                                  );
                                                },
                                                child: const Text("Accept"),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary:
                                                      Colors.red, // background
                                                ),
                                                onPressed: () async {
                                                  contexts.DeleteNotification(
                                                    token,
                                                    transactions[index]
                                                            ["transactionId"]
                                                        ["_id"],
                                                  );
                                                },
                                                child: const Text("Reject"),
                                              ),
                                            ],
                                          )
                                        : Container()
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox();
        },
      ),
      // return Container(
      //   child: Text(transactions[index]["transactionId"]["price"].toString()),
      // );
    );
  }
}
// Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            // children: [
                            //   Text("Name: " +
                            //       transactions[index]["FirstName"] +
                            //       transactions[index]["LastName"]),
                            //   Text("phone: " +
                            //       transactions[index]["Phone"].toString()),
                            //   Text("Email: " +
                            //       transactions[index]["Email"].toString()),
                            //   Text("Price: " +
                            //       transactions[index]["Price"].toString()),
                            //   Text("Status: " +
                            //       transactions[index]["Status"].toString()),
                            //   Text("Quantity: " +
                            //       transactions[index]["Quantity"].toString()),
                            //   Text("Margin: " +
                            //       transactions[index]["Margin"].toString()),
                            //   // ElevatedButton(
                            //   //   child: Text(""),
                            //   //   onPressed: () async {
                            //   //     await contexts
                            //   //         .updateNotifiaction(token, "Rejecion");
                            //   //   },
                            //   // ),
                            // ],
//                          ),