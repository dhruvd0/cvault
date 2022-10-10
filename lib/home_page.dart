import 'dart:async';

import 'package:cvault/Screens/admin_panel/widgets/admin_panel.dart';
import 'package:cvault/Screens/home/widgets/dashboard_page.dart';
import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/Screens/quote/quote.dart';
import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/drawer.dart';
import 'package:cvault/providers/dealers_provider.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Base Page For cvault, opens after logging in
///
/// Has a navigation bar, uses [_HomePageState.index] to change the current page for home
class HomePage extends StatefulWidget {
  ///
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
        UserTypes.customer);
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
    } else if (userType == UserTypes.admin) {
      setState(() {
        screens = [
          const DashboardPage(),
          const AdminPanel(),
          ProfilePage(),
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserType();
    callDealer();
    startTimer();
    print("hey");
  }

  bool timesec = false;
  void startTimer() {
    Timer.periodic(const Duration(seconds: 3), (t) {
      setState(() {
        timesec = true;
      });
      t.cancel(); //stops the timer
    });
  }

  void callDealer() async {
    setState(() {});
    var token = Provider.of<ProfileChangeNotifier>(context, listen: false);
    var data = Provider.of<DealersProvider>(context, listen: true);
    await data.fetchAndSetDealers(token.token);
    await data.getNonAcceptDealer();

    setState(() {});
    // ignore: newline-before-return
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (_, profileNotifier, k) {
        //var dealer = Provider.of<DealersProvider>(context, listen: true);

        return Consumer<DealersProvider>(
          builder: (s, dealer, k) {
            return Scaffold(
              drawerEnableOpenDragGesture: false,
              key: scaffoldKey,
              endDrawer: const MyDrawer(),
              backgroundColor: const Color(0xff1F1D2B),
              body:
                  //dealer
                  userType == UserTypes.dealer
                      ? timesec == true
                          ? dealer.allDealer.isNotEmpty
                              ? dealer.tempnonAccept.isNotEmpty
                                  ? Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            "Your Application is Under Progress",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    )
                                  : screens[index]
                              : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Your Application is rejected",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(0xff566749),
                                        ),
                                        child: Text("Log out"),
                                        onPressed: () {
                                          Provider.of<HomeStateNotifier>(
                                            context,
                                            listen: false,
                                          ).logout(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (builder) =>
                                                  const UserTypeSelectPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                      : screens[index],

              //dealer
              bottomNavigationBar: Theme(
                data: ThemeData(splashColor: Colors.transparent),
                child: NavigationBarTheme(
                  data: NavigationBarThemeData(
                    indicatorColor: userType == UserTypes.customer
                        ? const Color(0xffE47331)
                        : userType == UserTypes.dealer
                            ? const Color(0xff70755F)
                            : const Color(0xff0EE7AD),
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
                    labelBehavior:
                        NavigationDestinationLabelBehavior.onlyShowSelected,
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
                        : userType == UserTypes.admin
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
          },
        );
      },
    );
  }
}
