import 'package:cvault/Screens/usertype_select/user_select_button.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/// Launch Page for user to select "Dealer" or "Customer"
class UserTypeSelectPage extends StatefulWidget {
  ///
  const UserTypeSelectPage({Key? key}) : super(key: key);

  @override
  State<UserTypeSelectPage> createState() => _UserTypeSelectPageState();
}

class _UserTypeSelectPageState extends State<UserTypeSelectPage> {


 late Image image1;
  late Image image2;


  @override
  void initState() {
    super.initState();
    image1 = Image.asset("assets/dealer.png");
    image2 = Image.asset("assets/customer.png");

  }

  @override
  void didChangeDependencies() {
    precacheImage(image1.image, context);
    precacheImage(image2.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: const Color(0xff1F1D2B),
        body: Consumer<ProfileChangeNotifier>(
          builder: (s, profile, K) {
            

            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(left: 10, right: 10,top: 100),
                decoration: const BoxDecoration(
                  color: Color(0xff252836),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Welcome To CVault!",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            color: Color(0xffEDE1BA),
                            fontSize: 30,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
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
                      child: Column(
                        children: [
                          UserTypeButton(
                            userType: UserTypes.dealer,
                            image: image1,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              
                            },
                            child:  UserTypeButton(
                              userType: UserTypes.customer,
                              image:image2,
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
            );
          },
        ),
      ),
    );
  }
}
