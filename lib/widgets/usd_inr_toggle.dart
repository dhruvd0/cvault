import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

/// [Switch] widget to toggle between usd and inr version of a crypto currency
class USDToINRToggle extends StatelessWidget {
  ///

  const USDToINRToggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool status = false;

    return Consumer<HomeStateNotifier>(
      builder: (_, homeStateNotifier, __) {
        if (homeStateNotifier.state.loadStatus == LoadStatus.loading) {
          return Container();
        }

        return Consumer<ProfileChangeNotifier>(
          builder: (kk,profileNotifier,ss) {
            var userType = profileNotifier.profile.userType;

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                
               const Text.rich(
  TextSpan(
    children: [
      TextSpan(text: 'USD',style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),),
      TextSpan(
            text: '-',
            style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
      ),
      TextSpan(text: 'INR',style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),),
    ],
  ),
),
                // Container(
                //   decoration: BoxDecoration(border: Border.all(
                //     color: Colors.white,
                //     width: 0.9,
                //   ),
                //   borderRadius: BorderRadius.circular(20)),
                //   child: Switch(
                //     autofocus: true,
                //     activeColor: Colors.white,
                //     activeTrackColor: Colors.transparent,
                //     inactiveThumbColor: Colors.grey,
                //     inactiveTrackColor: Colors.black,
                //      value: !homeStateNotifier.state.isUSD,
                //     onChanged: (values) {
                //       // if (homeStateNotifier.state.cryptoCurrencies.isNotEmpty) {
                //       //   try {
                //       //     Provider.of<HomeStateNotifier>(
                //       //       context,
                //       //       listen: false,
                //       //     ).toggleIsUSD(!value);
                //       //   } on StateError {
                //       //     // TODO
                //       //   }
                //       // }
                //     },
                //   ),
                // ),
               const SizedBox(
                  height: 10,
                ),
                FlutterSwitch(
                  activeColor: Colors.white,
                  inactiveColor: Colors.transparent,
                  activeToggleColor:userType == UserTypes.customer? Color(0xffE47331):userType==UserTypes.dealer?Color(0xff566749):Color(0xff0EE7AD),
                  inactiveToggleColor: Colors.white,
                  switchBorder: Border.all(
                            color: Colors.white,
                            //width: 1.0,
                          ),
                          toggleBorder: Border.all(
                            color: Colors.transparent,
                            //width: 3.0,
                          ),
                width: 70.0,
                height: 30.0,
                
                toggleSize: 25.0,
                value: !homeStateNotifier.state.isUSD,
                borderRadius: 30.0,
               
                
                onToggle: (value) {
                  
                    if (homeStateNotifier.state.cryptoCurrencies.isNotEmpty) {
                        try {
                          Provider.of<HomeStateNotifier>(
                            context,
                            listen: false,
                          ).toggleIsUSD(!value);
                        } on StateError {
                          // TODO
                        }
                      }
                  
                },
              ),
              ],
            );
          },
        );
      },
    );
  }
}
