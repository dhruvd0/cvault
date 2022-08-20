

import 'package:cvault/Screens/notifications_screen.dart';
import 'package:cvault/Screens/settings/settting.dart';
import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
class MyDrawer extends StatefulWidget {
  ///
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
      builder: (kk, contexts, k) {
        return Consumer<ProfileChangeNotifier>(
          builder: (ss,profileNotifier,k) {
            var userType = profileNotifier.profile.userType;

            return Drawer(
              backgroundColor: Colors.green,
              child: Container(
                color: const Color(0xff1E2224),
                child: ListView(
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: Colors.black),
                      child: SizedBox(
                        height: 200,
                        width: 200,
                      ),
                    ),
                    ListTile(
                      trailing:  Icon(
                        Icons.settings,
                        size: 25,
                        color: userType==UserTypes.customer? Color(0xffE47331):userType==UserTypes.dealer?Color(0xff566749):Color(0xff0CFEBC),
                      ),
                      title: const Text(
                        "Settings",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const Settings(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      trailing:  Icon(
                        Icons.message,
                        size: 25,
                       color: userType==UserTypes.customer? Color(0xffE47331):userType==UserTypes.dealer?Color(0xff566749):Color(0xff0CFEBC),
                      ),
                      title: const Text(
                        "Messages",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      onTap: () {
                        /// TODO: navigate to messages
                      },
                    ),
                    userType==UserTypes.customer?const SizedBox(
                      height: 10,
                    ):SizedBox(),
                   userType==UserTypes.customer? ListTile(
                      trailing:  Icon(
                        Icons.notifications,
                        size: 25,
                        color: userType==UserTypes.customer? Color(0xffE47331):userType==UserTypes.dealer?Color(0xff566749):Color(0xff0CFEBC),
                      ),
                      title: const Text(
                        "Notification",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationScreen(),
                          ),
                        );
                      },
                    ):Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      trailing:  Icon(
                        Icons.exit_to_app,
                        size: 25,
                        color: userType==UserTypes.customer? Color(0xffE47331):userType==UserTypes.dealer?Color(0xff566749):Color(0xff0CFEBC),
                      ),
                      title: const Text(
                        "Log Out",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      onTap: () async {
                        Provider.of<HomeStateNotifier>(
                          context,
                          listen: false,
                        ).logout(context);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => const UserTypeSelectPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
