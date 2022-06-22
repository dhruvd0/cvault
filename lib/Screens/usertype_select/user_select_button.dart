import 'package:cvault/Screens/login/login_screen.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
class UserTypeButton extends StatelessWidget {
  ///
  const UserTypeButton({Key? key, required this.userType}) : super(key: key);

  ///
  final String userType;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        (await SharedPreferences.getInstance())
            .setString(SharedPreferencesKeys.userTypeKey, userType);
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
          Text(
            userType,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 130,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(4, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 1.5,
                color: Colors.white54,
              ),
            ),
            child: Image.asset(
              "assets/user.png",
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
