import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    Key? key,
    required this.hintText,
    this.showVerified,
    this.fixedValue,
    required this.fieldName,
  }) : super(key: key);
  final String hintText;

  final bool? showVerified;
  final String? fixedValue;
  final ProfileFields fieldName;
  String getInitialValueFromFieldName(Profile state) {
    switch (fieldName) {
      case ProfileFields.firstName:
        return state.firstName;
      case ProfileFields.middleName:
        return state.middleName;
      case ProfileFields.lastName:
        return state.lastName;
      case ProfileFields.email:
        return state.email;

      case ProfileFields.referalCode:
        return state.referalCode;
      case ProfileFields.phone:
        return state.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 8),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Consumer<ProfileChangeNotifier>(
        builder: (context, profileNotifier, _) {
          final state = profileNotifier.profile;
          List<ProfileFields> uncheckedFIelds = [
            ProfileFields.phone,
            ProfileFields.referalCode,
            ProfileFields.middleName,
          ];

          return TextFormField(
            initialValue: fixedValue ?? getInitialValueFromFieldName(state),
            onChanged: (string) {
              Provider.of<ProfileChangeNotifier>(context, listen: false)
                  .changeProfileField(string, fieldName);
            },
            validator: (string) {
              if (uncheckedFIelds.contains(fieldName)) {
                return null;
              }
              if (string == null) {
                return 'This should not be empty.';
              }
              if (string.isEmpty) {
                return 'This should not be empty.';
              }
              if (fieldName == ProfileFields.email) {
                return validator.email(string) ? null : 'Invalid email';
              }

              return null;
            },
            autocorrect: false,
            readOnly: fixedValue != null,
            style: const TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontFamily: 'Roboto',
              fontSize: 12,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xff1F1D2B),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              hintText: hintText,
              suffixIconColor: Colors.white,
              suffixStyle: const TextStyle(color: Colors.white, fontSize: 20),
              suffixIcon: !(showVerified ?? false)
                  ? null
                  : IconButton(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        /// TODO: on press
                      },
                    ),
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }
}
