import 'dart:ui';

import 'package:cvault/providers/dealers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Reporting extends StatelessWidget {
  const Reporting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1F1D2B),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:const Color(0xff252836),
        title: const Text(
          "New Dealers",
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
                                    text: " ${dealer.listData[index].lastName}",
                                    style:const TextStyle(
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
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  child: Text("Accept"),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text('In progress'),
                                      duration: const Duration(seconds: 1),
                                      action: SnackBarAction(
                                        label: 'ok',
                                        onPressed: () {},
                                      ),
                                    ));
                                  },
                                ),
                                ElevatedButton(
                                  child: Text("Reject"),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text('In progress'),
                                      duration: const Duration(seconds: 1),
                                      action: SnackBarAction(
                                        label: 'ACTION',
                                        onPressed: () {},
                                      ),
                                    ));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : CircularProgressIndicator(color: Colors.blue),
          );
        },
      ),
    );
  }
}
