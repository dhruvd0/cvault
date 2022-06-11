import 'package:cvault/Screens/admin_panel/widgets/admin_panel.dart';
import 'package:cvault/Screens/home/widgets/dashboard_page.dart';

import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/Screens/quote/quote.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/drawer.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  var screens = [
    const DashboardPage(),
    const Quote(),
    const AdminPanel(),
    ProfilePage(),
  ];
  String userType = UserTypes.admin;

  void getUserType() async {
    final user = ((await SharedPreferences.getInstance())
            .getString(SharedPreferencesKeys.userTypeKey) ??
        UserTypes.dealer);
    setState(() {
      userType = user;
    });
    if (userType == UserTypes.customer) {
      setState(() {
        screens = [
          const DashboardPage(),
          const Quote(),
          ProfilePage(),
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: scaffoldKey,
      endDrawer: const MyDrawer(),
      backgroundColor: const Color(0xff1E2224),
      body: screens[index],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: const Color.fromARGB(255, 165, 231, 243),
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: NavigationBar(
            height: 80,
            backgroundColor: Colors.transparent,
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: index,
            onDestinationSelected: (index) {
              setState(() {
                this.index = index;
              });
            },
            destinations: userType == UserTypes.customer
                ? [
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.home_filled,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: "Home",
                    ),
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.paid_outlined,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.paid,
                        color: Colors.white,
                      ),
                      label: "Quote",
                    ),
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: "Profile",
                    ),
                  ]
                : [
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.home_filled,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: "Home",
                    ),
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.paid_outlined,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.paid,
                        color: Colors.white,
                      ),
                      label: "Quote",
                    ),
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                      ),
                      label: "Admin Panel",
                    ),
                    const NavigationDestination(
                      selectedIcon: Icon(
                        Icons.person,
                        color: Colors.black,
                      ),
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      label: "Profile",
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
