import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/models/home_state.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/home_page.dart';
import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final items = [
    'Item 1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
  ];
  String? value;
  String? crypto = "Select currency";
  bool toggle = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  DropdownMenuItem<String> buildCurrencyList(String item) {
    var provider = Provider.of<HomeStateNotifier>(context, listen: false);
    final state = provider.state;
    String name =
        state.cryptoCurrencies.firstWhere((e) => e.wazirxKey == item).name;

    return DropdownMenuItem(
      value: item,
      alignment: Alignment.center,
      child: Text(
        name,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (builder) => const HomePage()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        centerTitle: true,
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: true,
          top: true,
          child: Consumer<ProfileChangeNotifier>(
            builder: (context, profileNotifier, _) {
              final state = profileNotifier.profile;
              final userType = state.userType;

              return Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    userType == UserTypes.admin
                        ? TickerSelectors()
                        : Container(),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        child: CircularProgressIndicator(),
                                      )
                                    : Flexible(
                                        child: homeNotifier
                                                .state.cryptoCurrencies.isEmpty
                                            ? SizedBox()
                                            : SizedBox(
                                                width: 120,
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton2(
                                                    isExpanded: false,
                                                    hint: Text(
                                                      'Select Item',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .hintColor,
                                                      ),
                                                    ),
                                                    items: HomeStateNotifier
                                                            .cryptoKeys(
                                                      homeNotifier.state.isUSD
                                                          ? 'usdt'
                                                          : 'inr',
                                                    )
                                                        .map(buildCurrencyList)
                                                        .toList(),
                                                    value: homeNotifier.state
                                                        .selectedCurrencyKey,
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        Provider.of<
                                                            HomeStateNotifier>(
                                                          context,
                                                          listen: false,
                                                        ).changeCryptoKey(
                                                          value.toString(),
                                                        );
                                                      }
                                                    },
                                                    dropdownDecoration:
                                                        BoxDecoration(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                              ],
                            );
                          },
                        ),
                        Column(
                          children: [
                            const Text(
                              "Default Margin",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 50,
                              width: 120,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  border: Border.all(
                                    width: 1.5,
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text(
                                    '20.0',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    userType == UserTypes.admin
                        ? ApplyMarginToggle()
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
                            builder: (builder) => const UserTypeSelectPage(),
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
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Container ApplyMarginToggle() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1.5, color: Colors.white),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Apply default \n margin to :",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Column(
            children: [
              const Text(
                "Global - Local",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              _globalToLocalSwitch(),
            ],
          ),
        ],
      ),
    );
  }

  Switch _globalToLocalSwitch() {
    return Switch(
      activeColor: Colors.green,
      activeTrackColor: Colors.lightGreen,
      value: toggle,
      onChanged: (value) {
        setState(() {
          toggle = value;
        });
      },
    );
  }

  Column TickerSelectors() {
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

  Column _dropdownSelectors() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 1.5, color: Colors.white),
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
            border: Border.all(width: 1.5, color: Colors.white),
          ),
          child: _localTickerDropdown(),
        ),
      ],
    );
  }

  DropdownButton<String> _localTickerDropdown() {
    return DropdownButton<String>(
      style: const TextStyle(color: Colors.black),
      underline: const SizedBox(),
      hint: const Center(
        child: Text(
          "Select Local Ticker",
          style: TextStyle(color: Colors.white),
        ),
      ),
      isExpanded: true,
      dropdownColor: Colors.transparent,
      items: items.map(buildMenuTickerItems).toList(),
      value: value,
      onChanged: (value) => setState(() {
        this.value = value;
      }),
    );
  }

  DropdownButton<String> _globalTickerDropdown() {
    return DropdownButton<String>(
      style: const TextStyle(color: Colors.black),
      underline: const SizedBox(),
      hint: const Center(
        child: Text(
          "Select Global Ticker",
          style: TextStyle(color: Colors.white),
        ),
      ),
      isExpanded: true,
      dropdownColor: Colors.transparent,
      items: items.map(buildMenuTickerItems).toList(),
      value: value,
      onChanged: (value) => setState(() {
        this.value = value;
      }),
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
}
