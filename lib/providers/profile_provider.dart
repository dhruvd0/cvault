import 'dart:convert';

import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum LoadStatus {
  initial,
  loading,
  done,
  error,
}

class ProfileChangeNotifier extends LoadStatusNotifier {
  Profile profile = ProfileInitial();

  FirebaseAuth authInstance = FirebaseAuth.instance;
  ProfileChangeNotifier([FirebaseAuth? mockAuth]) : super() {
    authInstance = mockAuth ?? FirebaseAuth.instance;
    authInstance.authStateChanges().asBroadcastStream().listen((event) async {
      if (event != null) {
        String? userType = (await SharedPreferences.getInstance())
            .getString(SharedPreferencesKeys.userTypeKey);
        await checkAndChangeUserType(event, userType, mockAuth);
      }
    });
  }

  Future<void> checkAndChangeUserType(
    User event, [
    String? userType,
    FirebaseAuth? mockAuth,
  ]) async {
    if (event.phoneNumber == '+91111111111') {
      (await SharedPreferences.getInstance()).setString(
        SharedPreferencesKeys.userTypeKey,
        UserTypes.admin,
      );
      userType = UserTypes.admin;
    }
    if (userType != null && userType.isNotEmpty) {
      changeUserType(mockAuth != null ? 'admin' : userType, event.uid);
    }
  }

  void emit(Profile newState) {
    profile = newState;
    notifyListeners();
  }

  void changeUserType(String newType, String uid) {
    switch (newType) {
      case UserTypes.admin:
        emit(Dealer.fromJson('admin', {'dealerId': uid})
          ..copyWith(userType: UserTypes.admin));
        assert(profile.userType == 'admin');
        break;

      case UserTypes.dealer:
        emit(Dealer.fromJson('dealer', {'dealerId': uid})
          ..copyWith(userType: UserTypes.dealer));
        break;
      case UserTypes.customer:
        emit(Customer.fromJson({'customerId': uid})
          ..copyWith(userType: UserTypes.customer));
        break;

      default:
    }
  }

  // ignore: long-method
  void changeProfileField(dynamic data, ProfileFields field) {
    var editProfile =
        profile.userType == 'dealer' ? profile as Dealer : profile as Customer;
    switch (field) {
      case ProfileFields.firstName:
        editProfile = editProfile.userType == 'dealer'
            ? (editProfile as Dealer).copyWith(firstName: data)
            : (editProfile as Customer).copyWith(firstName: data);

        break;
      case ProfileFields.middleName:
        editProfile = editProfile.userType == 'dealer'
            ? (editProfile as Dealer).copyWith(middleName: data)
            : (editProfile as Customer).copyWith(middleName: data);
        break;
      case ProfileFields.lastName:
        editProfile = editProfile.userType == 'dealer'
            ? (editProfile as Dealer).copyWith(lastName: data)
            : (editProfile as Customer).copyWith(lastName: data);
        break;
      case ProfileFields.email:
        editProfile = editProfile.userType == 'dealer'
            ? (editProfile as Dealer).copyWith(email: data)
            : (editProfile as Customer).copyWith(email: data);
        break;

      case ProfileFields.referralCode:
        editProfile = editProfile.userType == 'dealer'
            ? (editProfile as Dealer).copyWith(referralCode: data)
            : (editProfile as Customer).copyWith(referralCode: data);
        break;
      case ProfileFields.phone:
        // TODO: Handle this case.
        break;
    }
    emit(editProfile);
  }

  void reset() {
    emit(ProfileInitial());
  }

  // ignore: long-method
  Future<void> fetchProfile() async {
    var cachedProfile = await _fetchProfileFromCache();

    if (cachedProfile != null) {
      emit(cachedProfile);
      loadStatus = LoadStatus.done;
      notifyListeners();

      return;
    }

    String path = profile.userType == UserTypes.customer
        ? 'customer/getCustomer'
        : 'dealer/getDealer';

    var uri = "https://cvault-backend.herokuapp.com/$path";
    loadStatus = LoadStatus.loading;
    notifyListeners();
    var userType = profile.userType;
    userType = userType == 'admin' ? 'dealer' : userType;
    final response = await http.post(
      Uri.parse(
        uri,
      ),
      body: jsonEncode(
        {'${userType}Id': authInstance.currentUser!.uid},
      ),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['${userType}Data'];
      var user = profile.userType == 'dealer' || profile.userType == 'admin'
          ? Dealer.fromJson(profile.userType, data)
          : Customer.fromJson(data);
      emit(user);
      loadStatus = LoadStatus.done;

      notifyListeners();
      _saveProfileToCache();
    } else if (response.statusCode == 400) {
      var user = profile.userType == 'dealer' || profile.userType == 'admin'
          ? Dealer.fromJson(profile.userType, {})
          : Customer.fromJson({});
      emit(user);
      loadStatus = LoadStatus.done;
      notifyListeners();
    } else {
      loadStatus = LoadStatus.error;
      notifyListeners();
      throw Exception(path + response.statusCode.toString());
    }
    loadStatus = LoadStatus.done;
    notifyListeners();
  }

  Future<Profile?> _fetchProfileFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(UserTypes.admin)) {
      String dealerJson = await prefs.getString(UserTypes.admin) ?? '';

      return Dealer.fromJson('admin', jsonDecode(dealerJson));
    }
    if (prefs.containsKey(UserTypes.dealer)) {
      String dealerJson = await prefs.getString(UserTypes.dealer) ?? '';

      return Dealer.fromJson('dealer', jsonDecode(dealerJson));
    } else if (prefs.containsKey(UserTypes.customer)) {
      String customerJson = await prefs.getString(UserTypes.customer) ?? '';

      return Customer.fromJson(jsonDecode(customerJson));
    }

    return null;
  }

  Future<void> _saveProfileToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(profile.userType, jsonEncode(profile.toJson()));
  }

  Future<void> createNewProfile() async {
    String path = profile.userType == UserTypes.dealer
        ? 'dealer/createDealer'
        : 'customer/create-customer';
    Map<String, dynamic> data = profile.toJson();
    data['phone'] = FirebaseAuth.instance.currentUser!.phoneNumber;
    data['${profile.userType}Id'] = FirebaseAuth.instance.currentUser!.uid;
    var uri = "https://cvault-backend.herokuapp.com/$path";
    loadStatus = LoadStatus.loading;
    notifyListeners();
    final response = await http.post(
      Uri.parse(
        uri,
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    await _saveProfileToCache();
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)[
          profile.userType == UserTypes.dealer ? 'InsertDealer' : 'data'];
      emit(profile.userType == UserTypes.dealer
          ? Dealer.fromJson('dealer', json)
          : Customer.fromJson(json));
      loadStatus = LoadStatus.done;
    } else {
      loadStatus = LoadStatus.error;
      notifyListeners();
      throw Exception('$uri ${response.statusCode}');
    }
    notifyListeners();
  }
}
