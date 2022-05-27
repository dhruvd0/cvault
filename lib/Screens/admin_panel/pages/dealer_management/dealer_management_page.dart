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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: FloatingActionButton.extended(
                heroTag: 'inv_dealer',
                  backgroundColor: const Color(0xff03dac6),
                  foregroundColor: Colors.black,
                  onPressed: () async {
                   
                  },
                  label: Text(
                     'Invite Dealer',
                      style: TextStyle(
                        fontSize: 18,
                      ),),),

            ),
             SizedBox(
              height: 20,
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) {
                  ProfileState profile = ProfileInitial().copyWith(
                    firstName: 'Test Name',
                    email: 'test@gmail.com',
                    phone: '+9191111111111',
                    code: 'TP001',
                  );
            
                  return DealerTile(profile: profile);
                },
              ),
            ),
              SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: FloatingActionButton.extended(
                  backgroundColor: const Color(0xff03dac6),
                  foregroundColor: Colors.black,
                  onPressed: () async {},
                  label: Text('Toggle All',
                      style: TextStyle(
                        fontSize: 18,
                      ),),),
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
