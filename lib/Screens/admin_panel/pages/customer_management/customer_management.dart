import 'dart:convert';

import 'package:cvault/models/profile_models/profile.dart';
import 'package:cvault/Screens/admin_panel/pages/customer_management/customer_tile.dart';
import 'package:cvault/Screens/admin_panel/pages/dealer_management/dealer_tile.dart';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({Key? key}) : super(key: key);

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  Map<String, dynamic> data = {};
  List<Profile> customer = [];
  apiCall() async {
    final response = await http.get(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/customer/get-customer",
      ),
    );
    data = jsonDecode(response.body);
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: customer.length,
      itemBuilder: (BuildContext context, int index) {
        return DealerTile(dealer: customer![index]);
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
              child: (customer.isEmpty)
                  ? FutureBuilder(
                      future: apiCall(),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              Text("Try again");
                            }
                            List<ProfileState> temp = [];
                            data["data"].forEach(
                              (element) => temp.add(
                                ProfileInitial().copyWith(
                                  firstName: element["firstName"] +
                                      element[" middleName"] +
                                      element[" lastName"],
                                  email: element["email"],
                                  phone: element["phone"],
                                  code: element["customerId"],
                                ),
                              ),
                            );
                            customer = temp;
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
