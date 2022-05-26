import 'package:bloc/bloc.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitial());

  void changeProfileField(dynamic data, ProfileFields field) {
    var profileState = state;
    switch (field) {
      case ProfileFields.fullName:
        profileState = profileState.copyWith(fullName: data);
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
}
