import 'package:cvault/Screens/usertype_select/user_select_button.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
/// Launch Page for user to select "Dealer" or "Customer" 
class UserTypeSelectPage extends StatelessWidget {
  ///
  const UserTypeSelectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: ThemeColors.backgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.only(left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                "Welcome To CVault!",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  "Get started with selecting your user type",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: const [
                    Expanded(
                      child: UserTypeButton(
                        userType: UserTypes.dealer,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: UserTypeButton(
                        userType: UserTypes.customer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
