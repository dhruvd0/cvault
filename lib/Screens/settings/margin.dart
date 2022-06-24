import 'package:cvault/providers/margin_provider.dart';
import 'package:cvault/util/ui.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterMarginField extends StatelessWidget {
  const EnterMarginField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Default Margin",
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                width: 1.5,
                color: const Color.fromARGB(
                  255,
                  165,
                  231,
                  243,
                ),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const MarginInputTextField(),
          ),
        ),
      ],
    );
  }
}

class MarginInputTextField extends StatelessWidget {
  const MarginInputTextField({
    Key? key,
    this.editEnabled,
  }) : super(key: key);
  final bool? editEnabled;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Consumer<MarginsNotifier>(
          builder: (_, marginsNotifier, __) => TextFormField(
          enabled: editEnabled??true,
            initialValue: marginsNotifier.margin.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
            ),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            textAlign: TextAlign.center,
            onChanged: (string) {
              var parse = double.tryParse(string);
              if (parse == null) {
                showSnackBar('Enter a valid margin', context);

                return;
              }
              marginsNotifier.setMargin(parse);
            },
          ),
        ),
      ),
    );
  }
}
