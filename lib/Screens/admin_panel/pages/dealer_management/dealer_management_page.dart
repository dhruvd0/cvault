import 'package:cvault/Screens/admin_panel/pages/dealer_management/dealer_tile.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_state.dart';
import 'package:flutter/material.dart';

class DealerManagementPage extends StatelessWidget {
  const DealerManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Dealer Management",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xff1E2224),
      body: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          ProfileState profile =
              ProfileInitial().copyWith(firstName: 'Test Name');

          return DealerTile(profile: profile);
        },
      ),
    );
    
  }
}
