import 'dart:ui';

import 'package:cvault/Screens/login/login_screen.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
class UserTypeButton extends StatelessWidget {
  ///
  const UserTypeButton({Key? key, required this.userType, required this.image})
      : super(key: key);

  ///
  final String userType;
  final Image image;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<ProfileChangeNotifier>(
      builder: (s, profile, K) {
        return InkWell(
          onTap: () async {
            (await SharedPreferences.getInstance())
                .setString(SharedPreferencesKeys.userTypeKey, userType);
            profile.Role = userType.toString();

            print(userType);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return const LogInScreen();
                },
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 2,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: image,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
