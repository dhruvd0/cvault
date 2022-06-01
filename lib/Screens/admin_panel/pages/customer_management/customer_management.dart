import 'package:cvault/Screens/admin_panel/pages/customer_management/customer_tile.dart';
import 'package:cvault/models/profile_models/profile.dart';

import 'package:flutter/material.dart';

class CustomerManagementPage extends StatelessWidget {
  const CustomerManagementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Customer Management",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevation: 0,
      ),
      backgroundColor: const Color(0xff1E2224),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  Profile profile = ProfileInitial().copyWith(
                    firstName: 'Test Name',
                    email: 'test@gmail.com',
                    phone: '+9191111111111',
                  );

                  return CustomerTile(profile: profile);
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: FloatingActionButton.extended(
                backgroundColor: const Color(0xff03dac6),
                foregroundColor: Colors.black,
                onPressed: () async {
                  /// TODO: toggle all api
                },
                label: Text(
                  'Toggle All',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: FloatingActionButton.extended(
                heroTag: 'revert',
                backgroundColor: const Color(0xff03dac6),
                foregroundColor: Colors.black,
                onPressed: () async {
                  /// TODO: implement revert all to admin
                },
                label: Text(
                  'Revert All To Admin',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
