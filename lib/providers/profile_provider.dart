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

///
enum LoadStatus {
  ///
  initial,

  ///
  loading,

  ///
  done,

  ///
  error,
}

/// bloc to fetch profile, register profile, change user Type, and handle form for [Profile] page
class ProfileChangeNotifier extends LoadStatusNotifier {
  ///
  Profile profile = const ProfileInitial();

  ///
  late FirebaseAuth authInstance;

  ///
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

  /// Checks if the user is admin
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

  /// Utility to
  void emit(Profile newState) {
    profile = newState;
    notifyListeners();
  }

  /// Changes user type, and the type of [profile], either a [Dealer] or a [Customer]
  ///
  /// A [Dealer] can also be an admin with [Dealer.userTpe] as "admin"
  void changeUserType(String newType, String uid) {
    switch (newType) {
      case UserTypes.admin:
        emit(
          Dealer.fromJson('admin', {'dealerId': uid})
            ..copyWith(userType: UserTypes.admin),
        );
        assert(profile.userType == 'admin');
        break;

      case UserTypes.dealer:
        emit(
          Dealer.fromJson('dealer', {'dealerId': uid})
            ..copyWith(userType: UserTypes.dealer),
        );
        break;
      case UserTypes.customer:
        emit(
          Customer.fromJson({'customerId': uid})
            ..copyWith(userType: UserTypes.customer),
        );
        break;

      default:
    }
  }

  /// Changes specific props of [profile]
  void changeProfileField(dynamic data, ProfileFields field) {
    switch (field) {
      case ProfileFields.firstName:
        profile = profile.userType == 'dealer'
            ? (profile as Dealer).copyWith(firstName: data)
            : (profile as Customer).copyWith(firstName: data);

        break;
      case ProfileFields.middleName:
        profile = profile.userType == 'dealer'
            ? (profile as Dealer).copyWith(middleName: data)
            : (profile as Customer).copyWith(middleName: data);
        break;
      case ProfileFields.lastName:
        profile = profile.userType == 'dealer'
            ? (profile as Dealer).copyWith(lastName: data)
            : (profile as Customer).copyWith(lastName: data);
        break;
      case ProfileFields.email:
        profile = profile.userType == 'dealer'
            ? (profile as Dealer).copyWith(email: data)
            : (profile as Customer).copyWith(email: data);
        break;

      case ProfileFields.referralCode:
        profile = profile.userType == 'dealer'
            ? (profile as Dealer).copyWith(referralCode: data)
            : (profile as Customer).copyWith(referralCode: data);
        break;
      default:
    }

    notifyListeners();
  }

  ///
  void reset() {
    emit(const ProfileInitial());
  }

  /// Fetches and updates profile
  ///
  /// Checks profile data in shared preferences first
  Future<void> fetchProfile() async {
    loadStatus = LoadStatus.loading;
    notifyListeners();
    var cachedProfile = await _fetchProfileFromCache();

    if (cachedProfile != null) {
      emit(cachedProfile);
      loadStatus = LoadStatus.done;
      notifyListeners();

      return;
    }

    var uri =
        "https://cvault-backend.herokuapp.com/${profile.userType == UserTypes.customer ? 'customer/getCustomer' : 'dealer/getDealer'}";

    var userType = profile.userType == 'admin' ? 'dealer' : profile.userType;

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
      _parseAndEmitProfile(response, userType);
    } else if (response.statusCode == 400) {
      _parseUnregisteredProfile();
    } else {
      loadStatus = LoadStatus.error;
      notifyListeners();
      throw Exception(response.statusCode.toString());
    }
  }

  void _parseUnregisteredProfile() {
    var user = profile.userType == 'dealer' || profile.userType == 'admin'
        ? Dealer.fromJson(profile.userType, const {})
        : Customer.fromJson(const {});
    emit(user);
    loadStatus = LoadStatus.done;
    notifyListeners();
  }

  void _parseAndEmitProfile(http.Response response, String userType) {
    var data = jsonDecode(response.body)['${userType}Data'];
    var user = profile.userType == 'dealer' || profile.userType == 'admin'
        ? Dealer.fromJson(profile.userType, data)
        : Customer.fromJson(data);
    emit(user);
    loadStatus = LoadStatus.done;

    notifyListeners();
    _saveProfileToCache();
  }

  Future<Profile?> _fetchProfileFromCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(UserTypes.admin)) {
      String dealerJson = prefs.getString(UserTypes.admin) ?? '';

      return Dealer.fromJson('admin', jsonDecode(dealerJson));
    }
    if (prefs.containsKey(UserTypes.dealer)) {
      String dealerJson = prefs.getString(UserTypes.dealer) ?? '';

      return Dealer.fromJson('dealer', jsonDecode(dealerJson));
    } else if (prefs.containsKey(UserTypes.customer)) {
      String customerJson = prefs.getString(UserTypes.customer) ?? '';

      return Customer.fromJson(jsonDecode(customerJson));
    }

    return null;
  }

  Future<void> _saveProfileToCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(profile.userType, jsonEncode(profile.toJson()));
  }

  /// Registers a new customer or a new dealer, and fetches a profile if successfully created.
  Future<void> createNewProfile() async {
    Map<String, dynamic> data = profile.toJson();
    data['phone'] = FirebaseAuth.instance.currentUser!.phoneNumber;
    data['${profile.userType}Id'] = FirebaseAuth.instance.currentUser!.uid;
    var uri =
        "https://cvault-backend.herokuapp.com/${profile.userType == UserTypes.dealer ? 'dealer/createDealer' : 'customer/create-customer'}";
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
      emit(
        profile.userType == UserTypes.dealer
            ? Dealer.fromJson('dealer', json)
            : Customer.fromJson(json),
      );
      loadStatus = LoadStatus.done;
    } else {
      loadStatus = LoadStatus.error;

      throw Exception('$uri ${response.statusCode}');
    }
    notifyListeners();
  }
}
