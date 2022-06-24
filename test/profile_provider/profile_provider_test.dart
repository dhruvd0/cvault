import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import '../config/mocks.dart';

void main() {
  group('Tests to create and fetch a profile for :', () {
    for (var type in [UserTypes.dealer, UserTypes.customer]) {
      test(type, () async {
        String uid = const Uuid().v4();
        String phone = '+91${const Uuid().v4().substring(0, 10)}';
        mockAuth = MockFirebaseAuth(
          signedIn: true,
          mockUser: MockUser(
            uid: uid,
            phoneNumber: phone,
          ),
        );

        final profileProvider = ProfileChangeNotifier(mockAuth);
        profileProvider.changeUserType(type, uid);
        profileProvider.profile = type == 'dealer'
            ? (profileProvider.profile as Dealer).copyWith(
                firstName: 'test_$type',
                middleName: '',
                phone: phone,
                lastName: 'test_last_name',
                email: '$phone@gmail.com',
                referalCode: '1234',
              )
            : (profileProvider.profile as Customer).copyWith(
                firstName: 'test_$type',
                middleName: '',
                phone: phone,
                lastName: 'test_last_name',
                email: '$phone@gmail.com',
                referalCode: 'default_code',
              );
        await profileProvider.createNewProfile();
        await profileProvider.fetchProfile();
        expect(profileProvider.token, isNotEmpty);
      });
    }
  });
}
