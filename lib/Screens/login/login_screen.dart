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
  final GlobalKey<ScaffoldState> _scaffoldfkey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldfkey,
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
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("we sent it to the number $phone",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 55,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white)),
                    child: otpLoading == false
                        ? OTPTextField(
                            outlineBorderRadius: 25,
                            keyboardType: TextInputType.number,
                            otpFieldStyle: OtpFieldStyle(
                                errorBorderColor: Colors.black,
                                borderColor: Colors.black,
                                enabledBorderColor: Colors.black,
                                disabledBorderColor: Colors.black,
                                focusBorderColor: Colors.black),
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 20,
                            style: const TextStyle(
                                fontSize: 17, color: Colors.white),
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldStyle: FieldStyle.underline,
                            onCompleted: (pin) {
                              setState(() {
                                // showDialog(
                                //     context: context,
                                //     builder: (builder) => const Center(
                                //           child: CircularProgressIndicator(
                                //             color: Colors.white,
                                //           ),
                                //         ));
                                otpLoading == true;
                                verifyPin(pin);
                              });
                            },
                          )
                        : const CircularProgressIndicator(
                            backgroundColor: Colors.black,
                            color: Colors.white,
                          ),
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Enter your \nmobile number",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Text("we will send you a confirmation code",
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 14,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600),
                      )),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50)),
                    child: IntlPhoneField(
                      countryCodeTextColor: Colors.white,
                      dropDownIcon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        counter: Container(),
                        contentPadding: const EdgeInsets.only(top: 6),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        hintText: '00000-00000',
                        hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.4), fontSize: 16),
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
                  child: FloatingActionButton.extended(
                    backgroundColor: const Color(0xff03dac6),
                    foregroundColor: Colors.black,
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      verifyPhone();
                    },
                    label: isLoading == false
                        ? const Text('Get otp',
                            style: TextStyle(
                              fontSize: 18,
                            ))
                        : const CircularProgressIndicator(
                            color: Colors.white,
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
          _postLoginSubRoutine();
        },
        verificationFailed: (FirebaseAuthException e) {
          final snackBar = SnackBar(content: Text("${e.message}"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeSent: (String verficationId, int? resendToken) {
          setState(() {
            codeSent = true;
            verId = verficationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (mounted) {
            setState(() {
              verId = verificationId;
            });
          }
        },
        timeout: const Duration(seconds: 60));
  }
//loading naviagtion

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
      otpLoading == false;
      final snackBar = SnackBar(content: Text("${e.message}"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _postLoginSubRoutine() async {
    const snackBar = SnackBar(content: Text("Login Success"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('login', true);

    if (phone == "+911111111111") {
      await prefs.setString(SharedPreferencesKeys.userTypeKey, UserTypes.admin);
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (builder) => const HomePage()));
  }
}
