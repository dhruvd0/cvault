import 'package:cvault/Screens/Setting.dart';
import 'package:cvault/Screens/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
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
              trailing: const Icon(
                Icons.settings,
                size: 25,
                color: Color.fromARGB(255, 105, 243, 213),
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
                Navigator.pushReplacement(
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
              trailing: const Icon(
                Icons.message,
                size: 25,
                color: Color.fromARGB(255, 105, 243, 213),
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
            const SizedBox(
              height: 10,
            ),
            ListTile(
              trailing: const Icon(
                Icons.notifications,
                size: 25,
                color: Color.fromARGB(255, 105, 243, 213),
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
              onTap: () {
                /// TODO: navigate to notifications
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              trailing: const Icon(
                Icons.exit_to_app,
                size: 25,
                color: Color.fromARGB(255, 105, 243, 213),
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
                await FirebaseAuth.instance.signOut();

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (builder) => const LogInScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
