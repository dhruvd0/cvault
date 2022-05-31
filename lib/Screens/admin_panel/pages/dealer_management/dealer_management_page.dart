import 'dart:convert';

import 'package:cvault/Screens/admin_panel/pages/dealer_management/dealer_tile.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DealerManagementPage extends StatefulWidget {
  const DealerManagementPage({Key? key}) : super(key: key);

  @override
  State<DealerManagementPage> createState() => _DealerManagementPageState();
}

class _DealerManagementPageState extends State<DealerManagementPage> {
  List<dynamic> data = [];
  List<ProfileState> profiles = [];

  Future<void> apiCall() async {
    final response = await http.get(
      Uri.parse("https://cvault-backend.herokuapp.com/dealer/getAllDealer"),
    );

    data = jsonDecode(response.body);
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: profiles.length,
      itemBuilder: (BuildContext context, int index) {
        return DealerTile(profile: profiles[index]);
      },
    );
  }

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
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: FloatingActionButton.extended(
                heroTag: 'inv_dealer',
                backgroundColor: const Color(0xff03dac6),
                foregroundColor: Colors.black,
                onPressed: () async {
                  /// TODO: Invite Dealer
                },
                label: Text(
                  'Invite Dealer',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Flexible(
              child: (profiles.isEmpty)
                  ? FutureBuilder(
                      future: apiCall(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Expanded(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              return Text("Error");
                            }
                            List<ProfileState> temp = [];
                            data.forEach(
                              (element) => temp.add(
                                ProfileInitial().copyWith(
                                  firstName: element["name"],
                                  email: element["email"],
                                  phone: element["phone"],
                                  code: element["dealerId"],
                                ),
                              ),
                            );
                            profiles = temp;
                            return _buildListView();
                        }
                      },
                    )
                  : _buildListView(),
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
                  /// TODO: Toggle all
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
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
