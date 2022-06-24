import 'dart:convert';
import 'dart:developer';

import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  String token = '';

  ///
  ProfileChangeNotifier([FirebaseAuth? mockAuth]) : super() {
    authInstance = mockAuth ?? FirebaseAuth.instance;
    authInstance.authStateChanges().asBroadcastStream().listen((event) async {
      if (event != null) {
        String? userType = (await SharedPreferences.getInstance())
            .getString(SharedPreferencesKeys.userTypeKey);
        await checkAndChangeUserType(event, userType, mockAuth);
        if (Firebase.apps.isNotEmpty) {
          await login(event.uid);
        }
      }
    });
  }

  /// Get JWT token
  Future<void> login(String uid) async {
    assert(uid.isNotEmpty);
    var sharedPreferences = (await SharedPreferences.getInstance());
    final response = await http.post(
      Uri.parse("https://cvault-backend.herokuapp.com/token/token-login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        {
          "UID": uid,
        },
      ),
    );
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      var data = body['data'][0];
      token = data["token"];
      notifyListeners();
      await sharedPreferences.setString(SharedPreferencesKeys.token, token);
    } else if (response.statusCode > 404) {
      throw Exception('token/token-login, invalid response');
    }
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

      case ProfileFields.referalCode:
        profile = profile.userType == 'dealer'
            ? (profile as Dealer).copyWith(referalCode: data)
            : (profile as Customer).copyWith(referalCode: data);
        break;
      default:
    }

    notifyListeners();
  }

  ///
  void reset() {
    token = '';
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
    if (token.isEmpty) {
      await login(authInstance.currentUser!.uid);
    }
    if (token.isEmpty) {
      _emitUnregisteredProfile();

      return;
    }

    var uri = "https://cvault-backend.herokuapp.com/${profilePath()}";

    assert(token.isNotEmpty);
    final response = await _fetchProfileGetCall(uri);
    if (response.statusCode == 200) {
      _parseAndEmitProfile(response);
    } else if (response.statusCode == 400) {
      _emitUnregisteredProfile();
    } else {
      loadStatus = LoadStatus.error;
      notifyListeners();
      throw Exception(response.statusCode.toString());
    }
  }

  String profilePath() {
    switch (profile.userType) {
      case UserTypes.admin:
        return 'admin/getAdminData';
      case UserTypes.customer:
        return 'customer/getCustomer';
      case UserTypes.dealer:
        return 'dealer/getDealer';
    }

    return '';
  }

  Future<http.Response> _fetchProfileGetCall(String uri) {
    return http.get(
      Uri.parse(
        uri,
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $token',
      },
    );
  }

  void _emitUnregisteredProfile() {
    var user = profile.userType == 'dealer' || profile.userType == 'admin'
        ? Dealer.fromJson(profile.userType, const {})
        : Customer.fromJson(const {});
    emit(user);
    loadStatus = LoadStatus.done;
    notifyListeners();
  }

  void _parseAndEmitProfile(http.Response response) {
    var body = jsonDecode(response.body);
    log(body.toString());
    var data = body['${profile.userType}Data'];
    var user = profile.userType == 'dealer' || profile.userType == 'admin'
        ? Dealer.fromJson(profile.userType, data)
        : Customer.fromJson(data);
    if (user.phone == '1111111111') {
      user = (user as Dealer).copyWith(userType: 'admin');
    }
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
    _setDefaultreferalCodeForCustomer();

    Map<String, dynamic> data = profile.toJson();
    data['phone'] = authInstance.currentUser!.phoneNumber;
    data['UID'] = authInstance.currentUser!.uid;

    loadStatus = LoadStatus.loading;
    notifyListeners();
    final response = await http.post(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/${profile.userType == UserTypes.dealer ? 'dealer/createDealer' : 'customer/create-customer'}",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)[
          profile.userType == UserTypes.dealer ? 'InsertDealer' : 'data'];

      emit(
        profile.userType == UserTypes.dealer
            ? Dealer.fromJson('dealer', json)
            : Customer.fromJson(json),
      );
      await login(authInstance.currentUser!.uid);
      loadStatus = LoadStatus.done;

      await _saveProfileToCache();
    } else {
      loadStatus = LoadStatus.error;

      throw Exception('create profile: ${response.statusCode}');
    }
    notifyListeners();
  }

  void _setDefaultreferalCodeForCustomer() {
    if (profile.userType == UserTypes.customer) {
      if (profile.referalCode.isEmpty) {
        profile = (profile as Customer).copyWith(referalCode: 'default_code');
        notifyListeners();
      }
    }
  }
}
