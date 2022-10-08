import 'dart:developer';
import 'dart:ui';
import 'package:flutter/services.dart';

import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/home_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:cvault/util/ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool codeSent = false;
  bool isLoading = false;
  bool otpLoading = false;
  late String phone;
  late String verId;
  late String otp;
  bool _isLoading = false;
  bool _isOtpLogin = false;

  number() async {
    await Future.delayed(Duration(seconds: 30));
    setState(() {
      _isLoading = false;
    });
  }

  Newotp() async {
    await Future.delayed(const Duration(seconds: 40));
    setState(() {
      _isOtpLogin = false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Try Again"),
        ),
      );
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  OtpFieldController otpController = OtpFieldController();

  // ignore: long-method
  Future<void> verifyPhone() async {
    setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await FirebaseAuth.instance.signInWithCredential(credential);
        // await _postLoginSubRoutine();
        log('verification completed');
      },
      verificationFailed: (FirebaseAuthException e) {
        final snackBar = SnackBar(content: Text("${e.message}"));
        setState(() {
          otpLoading = false;
          codeSent = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          isLoading = false;
          codeSent = true;
          verId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (mounted) {
          setState(() {
            verId = verificationId;
          });
        }
      },
      timeout: const Duration(seconds: 10),
    );
  }

//loading navigation

  Future<void> verifyPin(String pin) async {
    setState(() {
      isLoading = true;
    });
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: pin);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      await postLoginSubRoutine();
    } on FirebaseAuthException catch (e) {
      setState(() {
        otpLoading = false;
        isLoading = false;
      });

      final snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  /// Fetches data and navigates user to the next screen after logging in
  // ignore: long-method
  Future<void> postLoginSubRoutine() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    var notifier = Provider.of<ProfileChangeNotifier>(context, listen: false);
    if (phone == "+911111111111") {
      await postLoginRoutineForAdmin(prefs, notifier);
      return;
    }

    await notifier.fetchProfile(context);
    if (notifier.profile.firstName.isNotEmpty) {
      // if (notifier.profile is Dealer) {
      //   if (!(notifier.profile as Dealer).active) {
      //     showSnackBar('Your account is disabled', context);
      //     await Navigator.pushReplacement(
      //       context,
      //       MaterialPageRoute(
      //         builder: (builder) => const UserTypeSelectPage(),
      //       ),
      //     );
      //     return;
      //   }
      // }
      const snackBar = SnackBar(content: Text("Welcome Back!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => const HomePage(),
        ),
      );
    } else {
      showSnackBar('Get Started', context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => ProfilePage(
            mode: ProfilePageMode.registration,
          ),
        ),
      );
    }
  }

  Future<void> postLoginRoutineForAdmin(
    SharedPreferences prefs,
    ProfileChangeNotifier notifier,
  ) async {
    await prefs.setString(SharedPreferencesKeys.userTypeKey, UserTypes.admin);
    notifier.changeUserType(
      UserTypes.admin,
      FirebaseAuth.instance.currentUser!.uid,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (builder) => const HomePage()),
    );
  }

  // ignore: long-method
  Consumer<ProfileChangeNotifier> getOtpButton(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (context, profileNotifier, _) {
        var userType = profileNotifier.Role;

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              height: 50,
              child: Container(
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 133, 128, 119),
                      blurRadius: 15,
                      spreadRadius: 1, //New
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 45,
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        userType == "Dealer"
                            ? const Color(0xff70755F)
                            : const Color(0xffE47331),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                        number();
                      });
                      verifyPhone();
                    },
                    child: _isLoading == false
                        ? const Text(
                            'Get otp',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: long-method
  Consumer<ProfileChangeNotifier> phoneInputField() {
    return Consumer<ProfileChangeNotifier>(
      builder: (context, profileNotifier, _) {
        var userType = profileNotifier.Role;

        return Container(
          decoration: BoxDecoration(
            color: Color(0xff1F1D2B),
            borderRadius: BorderRadius.circular(25),
          ),
          child: IntlPhoneField(
            showCountryFlag: true,
            autofocus: false,
            showDropdownIcon: true,
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusColor:
                  userType == "dealer" ? Color(0xff70755F) : Color(0xffE47331),
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              counter: Container(),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              hintText: '00000-00000',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 16,
              ),
            ),
            initialCountryCode: 'IN',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            onChanged: (phoneNumber) {
              setState(() {
                phone = phoneNumber.completeNumber;
              });
            },
          ),
        );
      },
    );
  }

  // ignore: long-method
  Widget submitButton(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (context, profileNotifier, _) {
        var userType = profileNotifier.Role;

        return Padding(
          padding: const EdgeInsets.only(left: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: Container(
              decoration: const BoxDecoration(),
              child: ElevatedButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    userType == "dealer"
                        ? Color(0xff70755F)
                        : Color(0xffE47331),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _isOtpLogin == true;
                    Newotp();
                  });
                  verifyPin(otp);
                },
                child: _isOtpLogin == false
                    ? const Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      )
                    : const CircularProgressIndicator(
                        color: Colors.white,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ignore: long-method
  Consumer<ProfileChangeNotifier> otpTextField(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (context, profileNotifier, _) {
        var userType = profileNotifier.Role;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              "Enter code sent \nto your number",
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
            Text(
              "we sent it to the number $phone",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff252836),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: userType == "dealer"
                            ? Color(0xff70755F)
                            : Color(0xffE47331),
                      ),
                    ),
                    padding: const EdgeInsets.only(left: 15),
                    child: Center(
                      child: !otpLoading
                          ? TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(6),
                              ],
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration.collapsed(
                                hintText: "   Enter Otp",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                otp = value;
                              },
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.black,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  submitButton(context),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: const Color(0xff1F1D2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (builder) => (const UserTypeSelectPage()),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Consumer<ProfileChangeNotifier>(
          builder: (_, profile, __) => Container(
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: codeSent
                ? profile.loadStatus == LoadStatus.loading || isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : otpTextField(context)
                : Consumer<ProfileChangeNotifier>(
                    builder: (_, profileNotifier, __) {
                      var userType = profileNotifier.Role;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Enter your \nmobile number",
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "we will send you a confirmation code",
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.all(25),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff252836),
                            ),
                            child: Column(
                              children: [
                                phoneInputField(),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 45,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Colors.white,
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        userType == "dealer"
                                            ? Color(0xff70755F)
                                            : Color(0xffE47331),
                                      ),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _isLoading = true;
                                        number();
                                      });
                                      verifyPhone();
                                      print(profileNotifier.Role);
                                    },
                                    child: _isLoading == false
                                        ? const Text(
                                            'Get otp',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          )
                                        : const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
      ),
      //floatingActionButton: codeSent ? null : getOtpButton(context),
    );
  }
}
