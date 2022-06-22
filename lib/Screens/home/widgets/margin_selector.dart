import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/providers/quote_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Widget to select the margin percentage
///
class MarginSelector extends StatelessWidget {
  ///
  const MarginSelector({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeStateNotifier>(
      builder: (context, homeStateNotifier, _) {
        final state = homeStateNotifier.state;
        // ignore: newline-before-return
        return Consumer<QuoteProvider>(
          builder: (_, quoteProvider, __) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                    top: 20,
                    bottom: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color.fromARGB(255, 165, 231, 243),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Default margin:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Currently applied to:',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Text(
                                quoteProvider.transaction.margin.toString() +
                                    "%",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                state.cryptoCurrencies.isEmpty
                                    ? ''
                                    : (state.isUSD
                                        ? 'Global price'
                                        : 'Local price'),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
