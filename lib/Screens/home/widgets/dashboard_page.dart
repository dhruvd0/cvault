import 'package:cvault/models/NonAcceptDealer.dart';
import 'package:cvault/providers/advertisement_provider.dart';
import 'package:cvault/Screens/settings/settting.dart';
import 'package:cvault/providers/dealers_provider.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/models/home_state.dart';
import 'package:cvault/Screens/home/widgets/margin_selector.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/widgets/usd_inr_toggle.dart';
import 'package:cvault/models/NonAcceptDealer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../drawer.dart';

/// Page to view crypto tickers, user details and Ads
class DashboardPage extends StatefulWidget {
  ///
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

/// @suraj96506 document this

class _DashboardPageState extends State<DashboardPage> {
  @override
  @override
  var formatter = NumberFormat('##,##,###');

  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawerEnableOpenDragGesture: false,
      key: scaffoldKey,
      endDrawer: const MyDrawer(),
      backgroundColor: const Color(0xff1F1D2B),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff252836),
        elevation: 0,
        toolbarHeight: 80,
        centerTitle: true,
        title: Consumer<ProfileChangeNotifier>(
          builder: (context, profileNotifier, _) {
            var userType = profileNotifier.profile.userType;
            if (userType.isEmpty) {
              return const Text('');
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                userType == UserTypes.customer
                    ? "Hello, ${profileNotifier.profile.firstName.isEmpty ? 'User' : profileNotifier.profile.firstName}"
                    : "Hello, ${profileNotifier.profile.firstName.isEmpty ? 'User' : profileNotifier.profile.firstName}.\n Welcome to ${userType[0].toUpperCase() + userType.substring(1)} Dashboard",
                textAlign: TextAlign.center,
                maxLines: 3,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          },
        ),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.menu),
                color: Colors.white,
                iconSize: 30,
              );
            },
          ),
        ],
      ),
      body: Consumer<ProfileChangeNotifier>(
        builder: (context, profileNotifier, _) {
          var userType = profileNotifier.profile.userType;

          return Consumer<HomeStateNotifier>(
            builder: (context, homeStateNotifier, _) {
              final state = homeStateNotifier.state;

              return state.loadStatus == LoadStatus.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        key: UniqueKey(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 20,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: userType == UserTypes.customer
                                    ? const Color(0xffE47331)
                                    : userType == UserTypes.dealer
                                        ? const Color(0xff70755F)
                                        : const Color(0xff0EE7AD),
                                border: Border.all(
                                  width: 0.5,
                                  color: const Color.fromARGB(
                                    255,
                                    165,
                                    231,
                                    243,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Settings(),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(
                                                5,
                                                0,
                                                0,
                                                0,
                                              ),
                                              child: Container(
                                                width: 100,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    15,
                                                  ),
                                                  color: userType ==
                                                          UserTypes.customer
                                                      ? const Color.fromARGB(
                                                          255,
                                                          239,
                                                          179,
                                                          89,
                                                        )
                                                      : userType ==
                                                              UserTypes.dealer
                                                          ? const Color(
                                                              0xff566749,
                                                            )
                                                          : const Color
                                                              .fromARGB(
                                                              255,
                                                              21,
                                                              158,
                                                              122,
                                                            ),
                                                ),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${state.selectedCurrencyKey.toUpperCase()}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontFamily: 'Poppins',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const Icon(
                                                        Icons
                                                            .arrow_drop_down_rounded,
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const USDToINRToggle(),
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
                                  homeStateNotifier.state is HomeInitial
                                      ? const Text("Loading")
                                      : Text(
                                          state.cryptoCurrencies.isEmpty
                                              ? ''
                                              : (state.isUSD
                                                  ? '\$${formatter.format(homeStateNotifier.currentCryptoCurrency().wazirxBuyPrice.toInt())}'
                                                      .replaceAll(',', ',')
                                                  : '₹${formatter.format(homeStateNotifier.currentCryptoCurrency().wazirxBuyPrice.toInt())}'
                                                      .replaceAll(',', ',')),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          homeStateNotifier.state is HomeInitial
                                              ? const Text("Loading")
                                              : Text(
                                                  state.cryptoCurrencies.isEmpty
                                                      ? ''
                                                      : (state.isUSD)
                                                          ? '\$${formatter.format(homeStateNotifier.currentCryptoCurrency().krakenPrice.toInt())}'
                                                              .replaceAll(
                                                                  ',', ',')
                                                          : '₹${formatter.format(homeStateNotifier.currentCryptoCurrency().krakenPrice.toInt())}'
                                                              .replaceAll(
                                                              ',',
                                                              ',',
                                                            ),
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
                                                  mainAxisSize:
                                                      MainAxisSize.max,
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
                                                      "${homeStateNotifier.state.difference.toStringAsFixed(2)}%",
                                                      style: const TextStyle(
                                                        fontFamily: 'Poppins',
                                                        fontSize: 16,
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
                                ],
                              ),
                            ),
                            userType == UserTypes.admin
                                ? Consumer<AdvertisementProvider>(
                                    builder: (
                                      context,
                                      provider,
                                      child,
                                    ) {
                                      return Container(
                                          // child: Image.network(
                                          //   provider.listData[0].imageLink
                                          //       .toString(),
                                          //   fit: BoxFit.fitWidth,
                                          // ),
                                          );
                                    },
                                  )
                                : const Add(),
                          ],
                        ),
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdvertisementProvider>(
      context,
    );
    // ignore: newline-before-return
    return Consumer<AdvertisementProvider>(
      builder: (
        context,
        provider,
        child,
      ) {
        return GestureDetector(
          onTap: () {
            provider.urlLauncher(
              provider.listData[0].redirectLink.toString(),
            );
          },
          child: provider.listData.isNotEmpty
              ? Container(
                  height: MediaQuery.of(context).size.width * 0.20,
                  margin: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(' AD'),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: Container(
                          child: Image.network(
                            provider.listData[0].imageLink.toString(),
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      const Text('AD  '),
                    ],
                  ),
                )
              : SizedBox(),
        );
      },
    );
  }
}
