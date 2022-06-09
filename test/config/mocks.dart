import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

final mockAuth = MockFirebaseAuth(
  signedIn: true,
  mockUser: MockUser(
    uid: 'g9wTu4GgDwNKBqlHjc24so5z4i73',
    phoneNumber: '+911111111111',
  ),
);
