import 'package:cvault/Screens/home/bloc/cubit/home_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Home Data Tests', () {
    test('Test to fetch data from wazirx', () async {
      final home = HomeCubit();

      await home.fetchCurrencyDataFromWazirX();

      expect(home.state.cryptoCurrencies, isNotEmpty);
      expect(home.state.selectedCurrencyKey, HomeCubit.cryptoKeys.first);
      expect(home.state.cryptoCurrencies.first.wazirxPrice > 0.0, true);
    });
  });
}
