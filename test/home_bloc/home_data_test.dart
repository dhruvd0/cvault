import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/margin_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import '../config/mocks.dart';

void main() {
  group('Home Data Tests:', () {
    test('Test to fetch data from wazirx', () async {
      final home = await _setupHomeStateNotifier();

      await home.fetchCurrencyDataFromWazirX();

      expect(home.state.cryptoCurrencies, isNotEmpty);
      expect(
        home.state.selectedCurrencyKey,
        HomeStateNotifier.cryptoKeys().first,
      );
      expect(home.state.cryptoCurrencies.first.wazirxBuyPrice > 0.0, true);
    });

    test('Test to fetch data from kraken', () async {
      final home = await _setupHomeStateNotifier();

      await home.getCryptoDataFromAPIs();

      expect(home.state.cryptoCurrencies, isNotEmpty);

      expect(home.state.cryptoCurrencies.first.krakenPrice > 0.0, true);
    });

    test('Test toggle USD-INR', () async {
      final home = await _setupHomeStateNotifier();

      await home.getCryptoDataFromAPIs();

      expect(home.state.cryptoCurrencies, isNotEmpty);

      expect(home.currentCryptoCurrency().krakenPrice > 0.0, true);

      await home.toggleIsUSD(false);
      expect(home.currentCryptoCurrency().krakenPrice > 0.0, true);
      await home.toggleIsUSD(true);
      expect(home.currentCryptoCurrency().krakenPrice > 0.0, true);
    });

    test('Test to change crypto key', () async {
      final home = await _setupHomeStateNotifier();

      await home.getCryptoDataFromAPIs();

      expect(home.state.cryptoCurrencies, isNotEmpty);

      expect(home.currentCryptoCurrency().krakenPrice > 0.0, true);

      await home.changeCryptoKey('shib');
      expect(home.currentCryptoCurrency().krakenPrice > 0.0, true);
      await home.toggleIsUSD(true);
      expect(home.currentCryptoCurrency().krakenPrice > 0.0, true);
      expect(home.currentCryptoCurrency().key, 'shib');
    });
  });
}

Future<HomeStateNotifier> _setupHomeStateNotifier() async {
  final profile =
      await setupProfileProvider(TestUserIds.admin, UserTypes.admin);
  final marginsNotifier = MarginsNotifier(profile);
  await marginsNotifier.getAllMargins();
  return HomeStateNotifier(
    firebaseAuthMock: mockAuth,
    marginsNotifier: marginsNotifier,
    profileChangeNotifier: profile,
  );
}
