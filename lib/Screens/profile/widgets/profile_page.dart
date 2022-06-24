import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:cvault/Screens/profile/widgets/common/profile_field.dart';
import 'package:cvault/Screens/profile/widgets/profile_header.dart';
import 'package:cvault/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ProfilePageMode { registration, edit }

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key, this.mode}) : super(key: key);
  ProfilePageMode? mode;
  static final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    mode = mode ?? ProfilePageMode.edit;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          centerTitle: true,
          title: Title(
            color: Colors.white,
            child: Text(
              mode == ProfilePageMode.registration
                  ? 'Register'
                  : 'Manage Profile',
            ),
          ),
          backgroundColor: const Color(0xff202427),
        ),
        backgroundColor: const Color(0xff202427),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 5,
                ),
                mode == ProfilePageMode.registration
                    ? Container()
                    : const ProfileHeader(),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: Text(
                        "First Name",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ProfileTextField(
                      hintText: 'First Name',
                      fieldName: ProfileFields.firstName,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: Text(
                        "Middle Name",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ProfileTextField(
                      hintText: 'Middle Name',
                      fieldName: ProfileFields.middleName,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: Text(
                        "Last Name",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ProfileTextField(
                      hintText: 'Last Name',
                      fieldName: ProfileFields.lastName,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 35.0, bottom: 8),
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Roboto',
                          fontSize: 12,
                        ),
                      ),
                    ),
                    ProfileTextField(
                      showVerified:
                          mode == ProfilePageMode.registration ? false : true,
                      hintText: 'Email',
                      fieldName: ProfileFields.email,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: const [
                          SizedBox(
                            height: 35,
                          ),
                          Text(
                            '+91',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 35.0, bottom: 8),
                              child: Text(
                                "Phone",
                                style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Flexible(
                              child: ProfileTextField(
                                showVerified: true,
                                hintText: 'Phone',
                                fieldName: ProfileFields.phone,
                                fixedValue: FirebaseAuth
                                        .instance.currentUser?.phoneNumber ??
                                    '',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                mode == ProfilePageMode.registration
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Padding(
                            padding: EdgeInsets.only(left: 35.0, bottom: 8),
                            child: Text(
                              "Referral",
                              style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Roboto',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          ProfileTextField(
                            hintText: 'Referral Code',
                            fieldName: ProfileFields.referalCode,
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
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
                          onPressed: () async {
                            if (mode == ProfilePageMode.registration) {
                              if (_formKey.currentState!.validate()) {
                                await Provider.of<ProfileChangeNotifier>(
                                  context,
                                  listen: false,
                                ).createNewProfile();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              }
                            } else {
                               if (_formKey.currentState!.validate()) {
                                await Provider.of<ProfileChangeNotifier>(
                                  context,
                                  listen: false,
                                ).updateProfile();
                               
                              }
                            }
                          },
                          label: Consumer<ProfileChangeNotifier>(
                            builder: ((context, notifier, child) =>
                                notifier.loadStatus == LoadStatus.loading
                                    ? const CircularProgressIndicator(
                                        color: Colors.black,
                                      )
                                    : Text(
                                        mode == ProfilePageMode.registration
                                            ? "Submit"
                                            : "Save",
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                      )),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
