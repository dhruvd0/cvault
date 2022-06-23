import 'package:cvault/Screens/usertype_select/usertype_select_page.dart';
import 'package:cvault/providers/home_provider.dart';
import 'package:cvault/models/home_state.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/Screens/profile/widgets/profile_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/widgets/usd_inr_toggle.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EnterMarginField extends StatelessWidget {
  const EnterMarginField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(
          height: 50,
          width: 120,
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
            child: Center(
              child: TextFormField(
                initialValue: 0.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
