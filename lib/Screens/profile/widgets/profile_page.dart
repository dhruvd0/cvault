
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:cvault/Screens/profile/widgets/common/profile_field.dart';
import 'package:cvault/Screens/profile/widgets/profile_header.dart';
import 'package:cvault/home_page.dart';
import 'package:cvault/util/ui.dart';
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

    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ));
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        title: Title(
          color: Colors.white,
          child: Text(
            mode == ProfilePageMode.registration
                ? 'Register'
                : 'Manage Profile',
          ),
        ),
        backgroundColor:  Color(0xff252836),
        elevation: 0,
      ),
      backgroundColor: const Color(0xff1F1D2B),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Consumer<ProfileChangeNotifier>(
          builder: (context, profileNotifier, _) {
            var userType = profileNotifier.profile.userType;
        
              return Container(
                margin:const EdgeInsets.only(top:20,left: 20,right: 20),
                
                decoration: BoxDecoration(
                  color:const Color(0xff252836),
                  borderRadius: BorderRadius.circular(15),),
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
                    Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                         
                              ProfileTextField(
                                showVerified: true,
                                hintText: 'Phone',
                                fieldName: ProfileFields.phone,
                                fixedValue: FirebaseAuth
                                        .instance.currentUser?.phoneNumber ??
                                    '',
                              ),
                            ],
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
                      padding: const EdgeInsets.only(left: 20,bottom: 10),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Container(
                            decoration: const BoxDecoration(
                              
                            ),
                            child: FloatingActionButton.extended(
                              backgroundColor:userType==UserTypes.customer? const Color(0xffE47331):userType==UserTypes.dealer?Color(0xff566749):Color(0xff0EE7AD),
                              
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
                                    final bool? result =
                                        await Provider.of<ProfileChangeNotifier>(
                                      context,
                                      listen: false,
                                    ).updateProfile();
                                    if (result ?? false) {
                                      showSnackBar('Profile Updated', context);
                                    }
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
                                            style:  TextStyle(
                                              fontSize: 18,
                                              color:userType==UserTypes.admin? Colors.black :Colors.white,
        
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
              );
            },
          ),
        ),
      ),
    );
  }
}
