import 'package:cvault/Screens/admin_panel/pages/dealer_management/customer_list.dart';
import 'package:cvault/Screens/reportingScreen.dart';
import 'package:cvault/constants/theme.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/dealers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DealerTile extends StatefulWidget {
  const DealerTile({Key? key, required this.dealer}) : super(key: key);
  final Dealer dealer;

  @override
  State<DealerTile> createState() => _DealerTileState();
}

class _DealerTileState extends State<DealerTile> {
  bool toggle = true;
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
          Container(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${widget.dealer.firstName}",
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
                  "Email: ${widget.dealer.email}",
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
                  "Mobile: ${widget.dealer.phone}",
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
                  "ID: ${widget.dealer.dealerId}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CustomerList(),
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: ThemeColors.lightGreenAccentColor,
                  size: 30,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Reporting(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.document_scanner,
                  color: ThemeColors.lightGreenAccentColor,
                  size: 30,
                ),
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
                  _changeActiveStatus(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _changeActiveStatus(BuildContext context) async {
    bool success = await Provider.of<DealersProvider>(context, listen: false)
        .changeDealerActiveState(widget.dealer.dealerId);
    String status = toggle ? 'Enabled' : 'Disabled';
    if (success) {
      final snackBar = SnackBar(content: Text("Dealer $status"));

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
