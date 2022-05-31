import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// This page will show customers of a specific dealer

class CustomerList extends StatelessWidget {
  const CustomerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E2224),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ), // back button, search and clear search
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Customer List"),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(color: Colors.grey[850]),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(""),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(FontAwesomeIcons.message),
                        SizedBox(height: 100),
                        Container(), // border button here
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
