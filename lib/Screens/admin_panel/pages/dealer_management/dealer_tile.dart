import 'package:cvault/Screens/admin_panel/pages/dealer_management/customer_list.dart';
import 'package:cvault/Screens/profile/cubit/cubit/profile_state.dart';
import 'package:cvault/constants/theme.dart';
import 'package:flutter/material.dart';

class DealerTile extends StatefulWidget {
  const DealerTile({Key? key, required this.profile}) : super(key: key);
  final ProfileState profile;

  @override
  State<DealerTile> createState() => _DealerTileState();
}

class _DealerTileState extends State<DealerTile> {
  bool toggle = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: " + widget.profile.firstName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Email: " + widget.profile.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Mobile: " + widget.profile.phone,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "ID: " + widget.profile.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CustomerList(),
                  ),
                ),
                child: Icon(
                  Icons.person,
                  color: ThemeColors.lightGreenAccentColor,
                  size: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Icon(
                Icons.document_scanner,
                color: ThemeColors.lightGreenAccentColor,
                size: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              Switch(
                activeColor: Colors.white,
                activeTrackColor: Colors.green,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.black,
                value: toggle,
                onChanged: (value) {
                  setState(() {
                    toggle = value;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
