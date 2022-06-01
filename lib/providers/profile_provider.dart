import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileChangeNotifier extends ChangeNotifier {
  Profile profile = ProfileInitial();
  ProfileChangeNotifier() : super() {
    FirebaseAuth.instance
        .authStateChanges()
        .asBroadcastStream()
        .listen((event) async {
      if (event != null) {
        String? userType = (await SharedPreferences.getInstance())
            .getString(SharedPreferencesKeys.userTypeKey);
        if (userType != null && userType.isNotEmpty) {
          changeUserType(userType);
        }
      }
    });
  }
  void emit(Profile newState) {
    profile = newState;
    notifyListeners();
  }

  void changeUserType(String newType) {
    emit(profile.copyWith(userType: newType));
  }

  void changeProfileField(dynamic data, ProfileFields field) {
    var Profile = profile;
    switch (field) {
      case ProfileFields.firstName:
        Profile = Profile.copyWith(firstName: data);
        break;
      case ProfileFields.middleName:
        Profile = Profile.copyWith(middleName: data);
        break;
      case ProfileFields.lastName:
        Profile = Profile.copyWith(lastName: data);
        break;
      case ProfileFields.email:
        Profile = Profile.copyWith(email: data);
        break;

      case ProfileFields.referralCode:
        Profile = Profile.copyWith(referralCode: data);
    }
    emit(Profile);
  }

  void reset() {
    emit(ProfileInitial());
  }

  Future<void> fetchProfile() async {
    //String phone = FirebaseAuth.instance.currentUser!.phoneNumber!;

    /// TODO: implement fetch profile

    bool isRegistered = false;
    // ignore: dead_code, change isRegistered to mock register api
    if (isRegistered) {
     
      emit(ProfileInitial());
    } else {
      emit(
        Dealer.mock(),
      );
    }
  }

  // Future<void> _fetchProfileFromCache() async {}
  // Future<void> _saveProfileToCache() async {}

  createNewProfile() async {
    final response = await http.get(
      Uri.parse("https://cvault-backend.herokuapp.com/dealer/createDealer"),
    );
    print(response);
  }
}
