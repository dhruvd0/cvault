import 'package:cvault/Screens/login/login_screen.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
class UserTypeButton extends StatelessWidget {
  ///
  const UserTypeButton({Key? key, required this.userType,required this.image}) : super(key: key);

  ///
  final String userType;
  final String  image;

  @override
  Widget build(
    BuildContext context,
  ) {
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
       
          const SizedBox(height: 10),
          Container(
            //height: 130,
            // padding: const EdgeInsets.all(25),
            
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                
              ),
            ),
          ),
        ],
      ),
    );
  }
}
