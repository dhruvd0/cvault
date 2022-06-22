import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// [Switch] widget to toggle between usd and inr version of a crypto currency
class USDToINRToggle extends StatelessWidget {
  ///

  const USDToINRToggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateNotifier>(
      builder: (_, homeStateNotifier, __) {
        if (homeStateNotifier.state.loadStatus == LoadStatus.loading) {
          return Container();
        }

        return Column(
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
              value: !homeStateNotifier.state.isUSD,
              onChanged: (value) {
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
  }
}

/// Toggle between global and local API ticker
class GLOBALToLOCALToggle extends StatelessWidget {
  ///
  const GLOBALToLOCALToggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateNotifier>(
      builder: (_, homeStateNotifier, __) {
        if (homeStateNotifier.state.loadStatus == LoadStatus.loading) {
          return Container();
        }

        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Text(
              'Global - Local',
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
              value: !homeStateNotifier.state.isUSD,
              onChanged: (value) {
                Provider.of<HomeStateNotifier>(
                  context,
                  listen: false,
                ).toggleIsUSD(!value);
              },
            ),
          ],
        );
      },
    );
  }
}
