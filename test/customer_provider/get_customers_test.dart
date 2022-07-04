import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/customer_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  test('Test to get all customers of a dealer', () async {
    final profileProvider =
        await setupProfileProvider(TestUserIds.dealer, UserTypes.dealer);
    final customersProvider = CustomerProvider(profileProvider);

    await profileProvider.login(TestUserIds.dealer);
    await customersProvider.fetchAndSetCustomers(profileProvider.token);
  });
}
