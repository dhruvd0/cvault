import 'package:cvault/constants/user_types.dart';
import 'package:cvault/providers/margin_provider.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/util/ui.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class EnterMarginField extends StatelessWidget {
  const EnterMarginField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileChangeNotifier>(
      builder: (s, profileNotifier, k) {
        var userType = profileNotifier.profile.userType;

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
                    color: userType == UserTypes.customer
                        ? Color(0xffE47331)
                        : userType == UserTypes.dealer
                            ? Color(0xff566749)
                            : Color(0xff0CFEBC),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const MarginInputTextField(),
              ),
            ),
          ],
        );
      },
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
    var userTypes = Provider.of<ProfileChangeNotifier>(context);

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Consumer<MarginsNotifier>(
          builder: (_, marginsNotifier, __) => TextFormField(
            enabled: editEnabled ?? true,
            initialValue: marginsNotifier.margin.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
            ),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: userTypes.profile.userType == UserTypes.admin
                    ? marginsNotifier.adminMargin.toString()
                    : marginsNotifier.dealerMargin.toString()),
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
