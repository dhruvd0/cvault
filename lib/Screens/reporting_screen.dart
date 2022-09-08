import 'dart:async';
import 'dart:ui';

import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/dealers_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Reporting extends StatefulWidget {
  const Reporting({Key? key}) : super(key: key);

  @override
  State<Reporting> createState() => _ReportingState();
}

class _ReportingState extends State<Reporting> {
  bool indicator = true;
  List<Dealer> dealers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  void startTimer() {
    Timer.periodic(const Duration(seconds: 20), (t) {
      setState(() {
        indicator = false; //set loading to false
      });
      t.cancel(); //stops the timer
    });
  }

  // void fetchApproveDealer() async {
  //   var token =
  //       Provider.of<ProfileChangeNotifier>(context, listen: false).token;
  //   final data = Provider.of<DealersProvider>(context, listen: false);
  //   dealers = data.dealers;
  //   await data.getNonAcceptDealer();
  // }

  @override
  Widget build(BuildContext context) {
    var token = Provider.of<ProfileChangeNotifier>(context).token;
    // void refresh() {
    //   fetchApproveDealer();
    // }

    return Scaffold(
      backgroundColor: const Color(0xff1F1D2B),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xff252836),
        title: const Text(
          "Non Approve Dealers",
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Consumer<DealersProvider>(
        builder: (s, dealer, k) {
          return Container(
            child: dealer.listData.isNotEmpty
                ? ListView.builder(
                    itemCount: dealer.listData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xff0CFEBC),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Name: ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: dealer.listData[index].firstName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        " ${dealer.listData[index].lastName}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'email: ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: dealer.listData[index].email,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'phone: ',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: dealer.listData[index].phone,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: Text("Accept"),
                                  style: ElevatedButton.styleFrom(
                                    primary: const Color(0xff35E065),
                                  ),
                                  onPressed: () async {
                                    await dealer
                                        .acceptDealer(
                                          token,
                                          dealer.listData[index].sId,
                                        )
                                        .then((value) =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content:
                                                  Text('dealer accepted'),
                                              duration: Duration(seconds: 1),
                                            )));
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Reject"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red, // background
                                  ),
                                  onPressed: () {
                                    dealer
                                        .deleteDealer(
                                          token,
                                          dealer.listData[index].sId,
                                        )
                                        .then((value) =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  const Text('In progress'),
                                              duration:
                                                  const Duration(seconds: 1),
                                              action: SnackBarAction(
                                                label: 'ACTION',
                                                onPressed: () {},
                                              ),
                                            )));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : indicator == true
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xff0CFEBC),
                        ),
                      )
                    : const Center(
                        child: Text(
                          "No Dealers for Approve",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
          );
        },
      ),
    );
  }
}
