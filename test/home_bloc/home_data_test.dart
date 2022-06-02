import 'package:cvault/providers/home_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Home Data Tests', () {
    test('Test to fetch data from wazirx', () async {
      final home = HomeStateNotifier();

      await home.fetchCurrencyDataFromWazirX();

      expect(home.state.cryptoCurrencies, isNotEmpty);
      expect(
          home.state.selectedCurrencyKey,
          HomeStateNotifier.cryptoKeys(home.state.isUSD ? 'usdt' : 'inr')
              .first);
      expect(home.state.cryptoCurrencies.first.wazirxPrice > 0.0, true);
    });

    test('Test to fetch data from kraken', () async {
      final home = HomeStateNotifier();

      await home.getCryptoDataFromAPIs();

      expect(home.state.cryptoCurrencies, isNotEmpty);

      expect(home.state.cryptoCurrencies.first.krakenPrice > 0.0, true);

      await home.toggleUSDToINR(true);
      expect(home.state.cryptoCurrencies.first.krakenPrice > 0.0, true);
    });
  });
}
