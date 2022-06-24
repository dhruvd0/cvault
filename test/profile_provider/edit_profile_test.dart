import 'package:cvault/constants/user_types.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';

import '../config/mocks.dart';

void main() {
  group('Tests to fetch and edit a profile for: :', () {
    for (var type in [UserTypes.dealer, UserTypes.customer]) {
      test(type, () async {
        final profileProvider = ProfileChangeNotifier(MockFirebaseAuth(
          signedIn: true,
          mockUser: MockUser(
            uid: type == 'dealer' ? TestUserIds.dealer : TestUserIds.customer,
            phoneNumber: '+911111111111',
          ),
        ),);
        profileProvider.changeUserType(
          type,
          type == 'dealer' ? TestUserIds.dealer : TestUserIds.customer,
        );
        await profileProvider.login(
          type == 'dealer' ? TestUserIds.dealer : TestUserIds.customer,
        );
        await profileProvider.fetchProfile();
        String randomFirstName =  '${const Uuid().v4()}-name';
        profileProvider.profile = type == 'dealer'
            ? (profileProvider.profile as Dealer).copyWith(
                firstName: randomFirstName,
              )
            : (profileProvider.profile as Customer).copyWith(
                firstName: randomFirstName,
              );
        await profileProvider.updateProfile();
        await profileProvider.fetchProfile();
        expect(profileProvider.profile.firstName, randomFirstName);
      });
    }
  });
}
