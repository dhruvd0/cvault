import 'package:cvault/Screens/profile/cubit/cubit/profile_cubit.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_state.dart';
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
  String getInitialValueFromFieldName(ProfileState state) {
    switch (fieldName) {
      case ProfileFields.firstName:
        return state.firstName;
      case ProfileFields.middleName:
        return state.middleName;
      case ProfileFields.lastName:
        return state.lastName;
      case ProfileFields.email:
        return state.email;
      case ProfileFields.code:
        return state.code;
      case ProfileFields.referralCode:
        return state.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 8),
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Consumer<ProfileNotifier>(
          builder: (context, profileNotifier, _) {
            final state = profileNotifier.state;

            return TextFormField(
              initialValue: fixedValue ?? getInitialValueFromFieldName(state),
              onChanged: (string) {
                Provider.of<ProfileNotifier>(context)
                    .changeProfileField(string, fieldName);
              },
              validator: (string) {
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
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: InputBorder.none,
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
                          debugPrint('pressed');
                        },
                      ),
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
