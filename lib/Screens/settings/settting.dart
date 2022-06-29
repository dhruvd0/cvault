import 'package:cvault/Screens/settings/crypto_drop_down.dart';
import 'package:cvault/Screens/settings/margin.dart';
import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/models/home_state.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/widgets/gobal_local_toggle.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Settings page
class Settings extends StatefulWidget {
  ///
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? crypto = "Select currency";
  final kraken = [
    'Kraken',
  ];

  String? krakenApiName;
  bool toggle = false;
  final wazir = [
    'WaxirX',
  ];

  String? wazirxApiName;

  Container applyMarginToggle() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          width: 1.5,
          color: const Color.fromARGB(255, 165, 231, 243),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Apply default \n margin to :",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Column(
            children: const [
              GLOBALToLOCALToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Column tickerSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ticker",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        _dropdownSelectors(),
      ],
    );
  }

  DropdownMenuItem<String> buildMenuTickerItems(String item) =>
      DropdownMenuItem(
        value: item,
        alignment: Alignment.center,
        child: Text(
          item,
          style: const TextStyle(color: Colors.white),
        ),
      );

  DropdownMenuItem<String> buildMenuTickerItemskraken(String item) =>
      DropdownMenuItem(
        value: item,
        alignment: Alignment.center,
        child: Text(
          item,
          style: const TextStyle(color: Colors.white),
        ),
      );

  Column _dropdownSelectors() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1.5,
              color: const Color.fromARGB(255, 165, 231, 243),
            ),
          ),
          child: _globalTickerDropdown(),
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              width: 1.5,
              color: const Color.fromARGB(255, 165, 231, 243),
            ),
          ),
          child: _localTickerDropdown(),
        ),
      ],
    );
  }

  DropdownButton<String> _localTickerDropdown() {
    return DropdownButton<String>(
      style: const TextStyle(color: Colors.transparent),
      underline: const SizedBox(),
      hint: const Center(
        child: Text(
          "Select Local Ticker",
          style: TextStyle(color: Colors.white),
        ),
      ),
      isExpanded: true,
      dropdownColor: Colors.black,
      items: wazir.map(buildMenuTickerItems).toList(),
      value: wazirxApiName,
      onChanged: (value) => setState(() {
        wazirxApiName = value;
      }),
    );
  }

  DropdownButton<String> _globalTickerDropdown() {
    return DropdownButton<String>(
      style: const TextStyle(color: Colors.transparent),
      underline: const SizedBox(),
      hint: const Center(
        child: Text(
          "Select Global Ticker",
          style: TextStyle(color: Colors.white),
        ),
      ),
      isExpanded: true,
      dropdownColor: Colors.black,
      items: kraken.map(buildMenuTickerItemskraken).toList(),
      value: krakenApiName,
      onChanged: (value) => setState(() {
        krakenApiName = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E2224),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        centerTitle: true,
        title: const Text("Settings"),
      ),
      body: Consumer<HomeStateNotifier>(
        builder: (context, homeStateNotifier, _) {
          final state = homeStateNotifier.state;
// ignore: newline-before-return
          return state.loadStatus == LoadStatus.loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: SafeArea(
                    bottom: true,
                    top: true,
                    child: Consumer<ProfileChangeNotifier>(
                      builder: (context, profileNotifier, _) {
                        final state = profileNotifier.profile;
                        final userType = state.userType;

                        return Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            top: 25,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              userType == UserTypes.admin
                                  ? tickerSelectors()
                                  : Container(),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Consumer<HomeStateNotifier>(
                                    builder: (context, homeNotifier, _) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Crypto Currency",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          homeNotifier.state is HomeInitial
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                              : Flexible(
                                                  child: homeNotifier
                                                          .state
                                                          .cryptoCurrencies
                                                          .isEmpty
                                                      ? const SizedBox()
                                                      : const SizedBox(
                                                          width: 120,
                                                          child:
                                                              CryptoDropdownButton(),
                                                        ),
                                                ),
                                        ],
                                      );
                                    },
                                  ),
                                  userType == UserTypes.customer
                                      ? Container()
                                      : const EnterMarginField(),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              userType == UserTypes.admin
                                  ? applyMarginToggle()
                                  : Container(),
                              const SizedBox(
                                height: 100,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => ProfilePage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Manage Profile",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                "Change password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 40),
                              InkWell(
                                onTap: () async {
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
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
