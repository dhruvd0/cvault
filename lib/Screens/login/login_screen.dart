import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/home_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  late String verId;
  late String phone;
  bool codeSent = false;
  bool isLoading = false;
  bool otpLoading = false;
  String otp = '';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xff1E2224),
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: codeSent
            ? Column(
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
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white),
                    ),
                    child: !otpLoading
                        ? OTPTextField(
                            onChanged: (string) {
                              setState(() {
                                otp = string;
                              });
                            },
                            outlineBorderRadius: 25,
                            keyboardType: TextInputType.number,
                            otpFieldStyle: OtpFieldStyle(
                              errorBorderColor: Colors.black,
                              borderColor: Colors.black,
                              enabledBorderColor: Colors.black,
                              disabledBorderColor: Colors.black,
                              focusBorderColor: Colors.black,
                            ),
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 20,
                            style: const TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                            ),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              verifyPin(pin);
                            },
                          )
                        : const CircularProgressIndicator(
                            backgroundColor: Colors.black,
                            color: Colors.white,
                          ),
                  ),
                ],
              )
            : Column(
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
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IntlPhoneField(
                      showCountryFlag: true,
                      showDropdownIcon: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
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
                        color: Colors.white,
                      ),
                      onChanged: (phoneNumber) {
                        setState(() {
                          phone = phoneNumber.completeNumber;
                        });
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: codeSent
          ? null
          : Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
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
                    child: FloatingActionButton.extended(
                      backgroundColor: const Color(0xff03dac6),
                      foregroundColor: Colors.black,
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        verifyPhone();
                      },
                      label: !isLoading
                          ? const Text(
                              'Get otp',
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
              ),
            ),
    );
  }

  Future<void> verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        await _postLoginSubRoutine();
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
      timeout: const Duration(seconds: 60),
    );
  }
//loading navigation

  Future<void> doTask() async {
    // Any future process here
    await Future.delayed(
      const Duration(seconds: 3),
    );
  }

  Future<void> verifyPin(String pin) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: pin);

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);

      await _postLoginSubRoutine();
    } on FirebaseAuthException catch (e) {
      otpLoading = false;
      final snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  // ignore: long-method
  Future<void> _postLoginSubRoutine() async {
    const snackBar = SnackBar(content: Text("Login Success"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', true);
    var notifier = Provider.of<ProfileChangeNotifier>(context, listen: false);
    if (phone == "+911111111111") {
      await prefs.setString(SharedPreferencesKeys.userTypeKey, UserTypes.admin);
      notifier.changeUserType(
        UserTypes.admin,
        FirebaseAuth.instance.currentUser!.uid,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (builder) => const HomePage()),
      );

      return;
    }

    await notifier.fetchProfile();
    if (notifier.profile.firstName.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (builder) => HomePage(),
        ),
      );
    } else {
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
}
