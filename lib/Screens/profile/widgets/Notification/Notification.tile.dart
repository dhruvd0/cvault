// import 'package:cvault/constants/theme.dart';
// import 'package:cvault/models/Notification.dart';
// import 'package:cvault/models/profile_models/customer.dart';
// import 'package:cvault/providers/customer_provider.dart';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class NotifiactionTile extends StatefulWidget {
//   const NotifiactionTile({Key? key, }) : super(key: key);
//   // final Notification notifiaction;

//   @override
//   State<NotifiactionTile> createState() => _NotifiactionileState();
// }

// class _NotifiactionileState extends State<NotifiactionTile> {
//   bool toggle = false;
 
//   @override
//   Widget build(BuildContext context) {
//     var provider=Provider.of<CustomerProvider>(context).notification;

//     return Container(
//       width: MediaQuery.of(context).size.width,
//       margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//       padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
//       decoration: BoxDecoration(
//         color: Colors.grey[850],
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: ListView.builder(
//         itemCount: provider.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ListTile(leading: provider[index].,)
//         },),
//     );
//   }
// }
