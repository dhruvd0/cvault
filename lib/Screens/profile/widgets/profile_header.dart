import 'package:cvault/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          width: 120.0,
          height: 120.0,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color(0xff131618),
                offset: Offset(-6, -5),
                spreadRadius: 0,
                blurRadius: 45.0,
              ),
            ],
            border: Border.all(
              width: 10,
              color: const Color(0xff1C1F22),
            ),
            // color: Color(0xff1E2022),
            borderRadius: BorderRadius.circular(40),
          ),
          child: CircleAvatar(
            child: Consumer<ProfileChangeNotifier>(
              builder: (context, profileNotifier, _) {
                var state = profileNotifier.profile;
                if (state.firstName.isEmpty) {
                  return const Text('AB');
                }

                return Text(state.firstName[0]);
              },
            ),
          ),
        ),
        Consumer<ProfileChangeNotifier>(
          builder: (context, profileNotifier, _) {
            var state = profileNotifier.profile;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.firstName.isEmpty
                      ? 'Name'
                      : '${state.firstName} ${state.middleName} ${state.lastName}',
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(
                  height: 20,
                ),
                 Text(
                'Referral Code: ${state.referalCode}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
