import 'dart:ui';

import 'package:cvault/providers/NotificationApiProvider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

    final token =
        Provider.of<ProfileChangeNotifier>(context, listen: false).token;

    transactions = await data.getAllNotification(token);
  }

  @override
  Widget build(BuildContext context) {
    String token = Provider.of<ProfileChangeNotifier>(context)
        .authInstance
        .currentUser!
        .uid;

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
      body: GestureDetector(
        child: Consumer<NotificationProvider>(
          builder: (kk, contexts, ll) {
            return transactions.isNotEmpty
                ? ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return _notificationTile(context, index,token);
                    },
                  )
                :const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  // ignore: long-method
  Widget _notificationTile(BuildContext context, index,token) {
    return Padding(
      padding: const EdgeInsets.only(bottom:10,left: 10,right: 10),
      child: Consumer<NotificationProvider>(
        builder: (ss,contexts,k) {
          return Container(
           
            decoration: BoxDecoration(
               color:transactions[index]["Status"]=="Reject"? Color(0xffEA4B63):transactions[index]["Status"]=="Accept"? Color(0xff35E065):transactions[index]["Transactiontype"]=="buy"?Color(0xff4895EF):transactions[index]["Transactiontype"]=="sell"?Color(0xffFFD44F):Color(0xff),
              borderRadius: BorderRadius.circular(15),),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: ExpansionTile(
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                backgroundColor:transactions[index]["Status"]=="Reject"? Color(0xffEA4B63):transactions[index]["Status"]=="Accept"? Color(0xff35E065):transactions[index]["Transactiontype"]=="buy"?Color(0xff4895EF):transactions[index]["Transactiontype"]=="sell"?Color(0xffFFD44F):Color(0xff),
               
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transactions[index]["FirstName"] +
                          " " +
                          transactions[index]["LastName"],
                          style: TextStyle(color: Colors.white,fontSize: 15),
                    ),
                    Text(
                      transactions[index]["Status"].toString(),
                      style: TextStyle(color: Colors.white,fontSize: 15),
                    ),
                     
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 20,),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transactions[index]["Price"].toString(),
                      style: TextStyle(color: Colors.white,fontSize: 15),),
                      Text(
                        DateFormat('yyyy-MM-dd \nH:m:s')
                            .format(DateTime.parse(transactions[index]["createdAt"])),
                            style: TextStyle(color: Colors.white,fontSize: 15),
                      ),
                    ],
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left:15,right: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Price",
                            style: TextStyle(color: Colors.white,fontSize: 15),),
                            Text(transactions[index]["Transactiontype"],
                            style: TextStyle(color: Colors.white,fontSize: 15),),
                            Text("Currency",
                            style: TextStyle(color: Colors.white,fontSize: 15),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(transactions[index]["Price"].toString(),
                              style: TextStyle(color: Colors.white,fontSize: 15),),
                              Text(transactions[index]["cryptoType"]+":"+" "+transactions[index]["Quantity"].toString(),
                              style: TextStyle(color: Colors.white,fontSize: 15),),
                            ],
                          ),
                        ),
                       const SizedBox(height: 20,),
                        SizedBox(
                     child:transactions[index]["Status"]=="Recieved"?   Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
            ElevatedButton(onPressed: ()async{
              await contexts
                       .updateNotifiaction(token, "Accept");
            },child:const Text("Accept"),),
           const SizedBox(width: 20,),
            ElevatedButton(onPressed: ()async{
              await contexts
                       .updateNotifiaction(token, "Rejecion");
            },child:const Text("Reject"),),
                        ],):Container(),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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