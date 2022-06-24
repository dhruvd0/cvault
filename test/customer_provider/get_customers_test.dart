import 'package:cvault/providers/customer_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  test('Test to get all customers of a dealer', () async {
    final customersProvider = CustomerProvider();
    final profileProvider = ProfileChangeNotifier();
    await profileProvider.login(TestUserIds.dealer);
    await customersProvider.fetchAndSetCustomers(profileProvider.token);

  });
}
