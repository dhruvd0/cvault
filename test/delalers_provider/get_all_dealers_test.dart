import 'package:cvault/providers/dealers_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  test('Test to get all dealers', () async {
    final dealersProvider = DealersProvider();
    final profileProvider = ProfileChangeNotifier(
      MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(
          uid: TestUserIds.dealer,
          phoneNumber: '+911111111111',
        ),
      ),
    );
    await profileProvider.login(TestUserIds.dealer);
    await dealersProvider.fetchAndSetDealers();
    expect(dealersProvider.dealers, isNotEmpty);
  });
}
