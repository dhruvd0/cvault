import 'package:cvault/constants/theme.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerTile extends StatefulWidget {
  const CustomerTile({Key? key, required this.customer}) : super(key: key);
  final Customer customer;

  @override
  State<CustomerTile> createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile> {
  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (s,profileNotifier,k) {
         var userType = profileNotifier.profile.userType;

        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          decoration: BoxDecoration(
            color:userType==UserTypes.dealer? Color(0xff566749):Color(0xFF0CFEBC),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Customer: ${widget.customer.firstName}",
                        style:  TextStyle(
                          color: userType==UserTypes.dealer?Colors.white:Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Icon(
                        Icons.chat,
                        color: Color.fromARGB(255, 20, 31, 30),
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Email: ${widget.customer.email}",
                    style:  TextStyle(
                      color: userType==UserTypes.dealer?Colors.white:Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Mobile: ${widget.customer.phone}",
                        style:  TextStyle(
                          color: userType==UserTypes.dealer?Colors.white:Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromARGB(255, 30, 37, 37),
                          ),
                        ),
                        child:  Text(
                          'Change Dealer',
                          style: TextStyle(color: userType==UserTypes.dealer?Colors.white:Colors.black,),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Dealer : \n${widget.customer.uid}",
                        style:  TextStyle(
                          color: userType==UserTypes.dealer?Colors.white:Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Switch(
                        activeColor: Colors.white,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.black,
                        value: toggle,
                        onChanged: (value) {
                          setState(() {
                            toggle = value;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
