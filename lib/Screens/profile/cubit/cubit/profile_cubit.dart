import 'package:bloc/bloc.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_state.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial()) {
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
  void changeUserType(String newType) {
    emit(state.copyWith(userType: newType));
  }

  void changeProfileField(dynamic data, ProfileFields field) {
    var profileState = state;
    switch (field) {
      case ProfileFields.firstName:
        profileState = profileState.copyWith(firstName: data);
        break;
      case ProfileFields.middleName:
        profileState = profileState.copyWith(middleName: data);
        break;
      case ProfileFields.lastName:
        profileState = profileState.copyWith(lastName: data);
        break;
      case ProfileFields.email:
        profileState = profileState.copyWith(email: data);
        break;
      case ProfileFields.code:
        profileState = profileState.copyWith(code: data);
        break;
      case ProfileFields.referralCode:
        profileState = profileState.copyWith(referralCode: data);
    }
    emit(profileState);
  }

  void reset() {
    emit(ProfileInitial());
  }

  Future<void> fetchProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    /// TODO: implement fetch profile here
    ///
    ///
    ///

    bool isRegistered = false;
    if (isRegistered) {
      var map = <String, dynamic>{};
      emit(ProfileState.fromMap(map));
    } else {
      emit(NewProfile(userType: state.userType, uid: uid,phone: '+919000000001'));
    }
  }

  createNewProfile() {}
}
