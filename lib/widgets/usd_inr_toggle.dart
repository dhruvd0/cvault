import 'package:cvault/providers/home_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class USDToINRToggle extends StatelessWidget {
  const USDToINRToggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateNotifier>(
      builder: (_, homeStateNotifier, __) => Column(
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
              Provider.of<HomeStateNotifier>(
                context,
                listen: false,
              ).toggleIsUSD(!value);
            },
          ),
        ],
      ),
    );
  }
}