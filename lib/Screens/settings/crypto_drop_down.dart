import 'package:cvault/providers/home_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CryptoDropdownButton extends StatelessWidget {
  const CryptoDropdownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateNotifier>(
      builder: (_, homeNotifier, __) => DropdownButtonHideUnderline(
        child: DropdownButton2(
          isExpanded: true,
          hint: Text(
            'Select Item',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(
                context,
              ).hintColor,
            ),
          ),
          items: HomeStateNotifier.cryptoKeys()
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  alignment: Alignment.center,
                  child: _CryptoDropdownText(item: item),
                ),
              )
              .toList(),
          value: homeNotifier.state.selectedCurrencyKey,
          onChanged: (value) {
            if (value != null) {
              Provider.of<HomeStateNotifier>(
                context,
                listen: false,
              ).changeCryptoKey(
                value.toString(),
              );
            }
          },
          dropdownDecoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class _CryptoDropdownText extends StatelessWidget {
  final String item;

  const _CryptoDropdownText({required this.item});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateNotifier>(
      builder: (_, homeNotifier, __) => Text(
        homeNotifier.state.cryptoCurrencies
            .firstWhere((e) => e.key == item)
            .name,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
