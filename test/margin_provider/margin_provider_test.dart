import 'dart:math';

import 'package:cvault/providers/margin_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  group('Margin Tests:', () {
    test('Test to set and get admin margin', () async {
      final profileChangeNotifier =
          await setupProfileProvider(TestUserIds.admin,'admin');
      final marginProvider = MarginsNotifier(profileChangeNotifier);
      double randomMargin = Random().nextDouble();
      await marginProvider.setMargin(randomMargin);
      await marginProvider.getMargin('admin');
      expect(marginProvider.adminMargin, randomMargin);
    });

    test('Test to set and get dealer margin', () async {
      final profileChangeNotifier =
          await setupProfileProvider(TestUserIds.dealer,'dealer');
      final marginProvider = MarginsNotifier(profileChangeNotifier);
      double randomMargin = Random().nextDouble();
      await marginProvider.setMargin(randomMargin);
      await marginProvider.getMargin('dealer',dealerCode: 'default_code');
      expect(marginProvider.dealerMargin, randomMargin);
    });
  });
}
