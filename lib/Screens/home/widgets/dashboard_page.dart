import 'package:cvault/Screens/Setting.dart';
import 'package:cvault/Screens/home/bloc/cubit/home_cubit.dart';
import 'package:cvault/Screens/home/bloc/cubit/home_state.dart';
import 'package:cvault/Screens/home/widgets/margin_selector.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_cubit.dart';
import 'package:cvault/Screens/profile/widgets/profile.dart';
import 'package:cvault/constants/user_types.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../drawer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool toggle = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int LocalPrice = 2533118;
    double globalPrice = 2415313.58;
    double difference = 100 * ((LocalPrice - globalPrice) / globalPrice);
    double fixedDifference = double.parse(difference.toStringAsFixed(2));

    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: scaffoldKey,
      endDrawer: const MyDrawer(),
      backgroundColor: const Color(0xff1E2224),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 100,
        centerTitle: true,
        title: Consumer<ProfileNotifier>(
          builder: (context, profileNotifier, _) {
            var userType = profileNotifier.state.userType;

            return Text(
              "Hello, ${profileNotifier.state.firstName.isEmpty ? 'User' : profileNotifier.state.firstName}.\n Welcome to ${userType[0].toUpperCase() + userType.substring(1)} Dashboard",
              textAlign: TextAlign.center,
              maxLines: 3,
              style: const TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 20,
              ),
            );
          },
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (builder) => ProfilePage()),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.5),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              foregroundImage: NetworkImage(
                "https://cdn.pixabay.com/photo/2020/06/01/22/23/eye-5248678__340.jpg",
              ),
            ),
          ),
        ),
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu),
              color: Colors.white,
              iconSize: 30,
            );
          }),
        ],
      ),
      body: Consumer<ProfileNotifier>(
        builder: (context, profileNotifier, _) {
          var userType = profileNotifier.state.userType;

          return Consumer<HomeStateNotifier>(
            builder: (context, homeStateNotifier, _) {
              final state = homeStateNotifier.state;

              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.network(
                                  'https://picsum.photos/seed/269/600',
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Settings(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  5,
                                  0,
                                  0,
                                  0,
                                ),
                                child: Text(
                                  '1 ${state.selectedCurrencyKey.toUpperCase()}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              'USD - INR',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                            Switch(
                              autofocus: true,
                              activeColor: Colors.white,
                              activeTrackColor: Colors.lightGreen,
                              inactiveThumbColor: Colors.grey,
                              inactiveTrackColor: Colors.black,
                              value: toggle,
                              onChanged: (value) {
                                setState(() {
                                  toggle = value;
                                });
                                Provider.of<HomeStateNotifier>(
                                  context,
                                  listen: false,
                                ).toggleUSDToINR(!value);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      userType == UserTypes.admin
                          ? 'Local price (Wazirx)'
                          : 'Buy Price',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    homeStateNotifier is HomeInitial
                        ? const Text("Loading")
                        : Text(
                            (state.isUSD ? '\$' : '₹') +
                                state.cryptoCurrencies
                                    .firstWhere((element) =>
                                        element.key ==
                                        state.selectedCurrencyKey)
                                    .wazirxPrice
                                    .toString(),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontSize: 32,
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userType == UserTypes.admin
                                  ? 'Global price (Kraken)'
                                  : 'Sell Price',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              (state.isUSD ? '\$' : '₹') + '35253435245',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 32,
                              ),
                            ),
                          ],
                        ),
                        userType == UserTypes.admin
                            ? Column(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Text(
                                        'Difference',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        fixedDifference.toString(),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    userType == UserTypes.admin
                        ? const MarginSelector()
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    userType == UserTypes.admin
                        ? Container()
                        : Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Text('AD'),
                                  Center(
                                    child: Image.asset("assets/test_ad.gif"),
                                  ),
                                  const Text('AD'),
                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
