import 'package:cvault/Screens/settings/margin.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarginPercentageField extends StatelessWidget {
  const MarginPercentageField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (_, profileNotifier, k) {
        var userType = profileNotifier.profile.userType;
        // ignore: newline-before-return
        return Consumer<QuoteProvider>(
          builder: (_, quoteProvider, __) => userType == UserTypes.customer
              ? Container()
              : Column(
                  children: [
                    const Text(
                      "Margin %",
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
                            color: const Color.fromARGB(255, 165, 231, 243),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const MarginInputTextField(
                          editEnabled: true,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
