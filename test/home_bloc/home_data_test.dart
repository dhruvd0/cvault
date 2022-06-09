import 'package:cvault/providers/home_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Home Data Tests', () {
    test('Test to fetch data from wazirx', () async {
      final home = HomeStateNotifier();

      await home.fetchCurrencyDataFromWazirX();

      expect(home.state.cryptoCurrencies, isNotEmpty);
<<<<<<< Updated upstream
      expect(home.state.selectedCurrencyKey,HomeStateNotifier.cryptoKeys.first);
=======
      expect(
        home.state.selectedCurrencyKey,
        HomeStateNotifier.cryptoKeys(home.state.isUSD ? 'usdt' : 'inr').first,
      );
>>>>>>> Stashed changes
      expect(home.state.cryptoCurrencies.first.wazirxPrice > 0.0, true);
    });
  });
}
