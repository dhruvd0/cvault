import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/margin_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final mockAuth = MockFirebaseAuth(
  signedIn: true,
  mockUser: MockUser(
    uid: 'g9wTu4GgDwNKBqlHjc24so5z4i73',
    phoneNumber: '+911111111111',
  ),
);

Future<QuoteProvider> setupQuoteProvider() async {
  HomeStateNotifier homeStateNotifier = HomeStateNotifier(mockAuth);
  ProfileChangeNotifier profileChangeNotifier =
      await setupProfileProvider(TestUserIds.dealer, 'dealer');
  await Future.wait([
    homeStateNotifier.getCryptoDataFromAPIs(),
  ]);
  expect(profileChangeNotifier.profile.uid, 'YWOid15gXkO93TIzlAOM3c84ya82');
  expect(profileChangeNotifier.profile.phone, isNotEmpty);
  expect(profileChangeNotifier.profile.userType, UserTypes.dealer);
  MarginsNotifier marginsNotifier = MarginsNotifier(profileChangeNotifier);
  await marginsNotifier.getAllMargins();
  final quoteProvider = QuoteProvider(
    homeStateNotifier: homeStateNotifier,
    profileChangeNotifier: profileChangeNotifier,
    marginsNotifier: marginsNotifier,
  );
  quoteProvider.updateWithHomeNotifierState();
  quoteProvider.updateWithProfileProviderState();

  return quoteProvider;
}

Future<ProfileChangeNotifier> setupProfileProvider(
  String testID,
  String userType,
) async {
  (await SharedPreferences.getInstance()).clear();
  ProfileChangeNotifier profileChangeNotifier = ProfileChangeNotifier(mockAuth);

  profileChangeNotifier.changeUserType(
    userType,
    testID,
  );
  await profileChangeNotifier.login(testID);
  await profileChangeNotifier.fetchProfile();
  expect(profileChangeNotifier.profile.uid, testID);
  expect(profileChangeNotifier.profile.phone, isNotEmpty);

  return profileChangeNotifier;
}

class TestUserIds {
  static const String admin = 'g9wTu4GgDwNKBqlHjc24so5z4i73';
  static const String dealer = 'YWOid15gXkO93TIzlAOM3c84ya82';
  static const String customer = 'lkOorJiJFQPEreo9Y16sLlyhDYL2';
}
