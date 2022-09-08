import 'package:cvault/Screens/admin_panel/pages/customer_management/customer_management.dart';
import 'package:cvault/Screens/admin_panel/pages/dealer_management/dealer_management_page.dart';
import 'package:cvault/Screens/reporting_screen.dart';
import 'package:cvault/Screens/advertisment.dart';
import 'package:cvault/providers/dealers_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPanelGrid extends StatelessWidget {
  const AdminPanelGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DealersProvider>(context);

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DealerManagementPage(),
              ),
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/trans1.jpeg",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CustomerManagementPage(),
              ),
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/trans2.jpeg",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
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
                builder: (context) => const Advertisment(),
              ),
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(4, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    "assets/trans3.jpeg",
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Consumer<DealersProvider>(
          builder: (s, dealer, k) {
            return GestureDetector(
              onTap: () {
                dealer.listData.clear();
                dealer.getNonAcceptDealer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Reporting(),
                  ),
                );
              },
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(4, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "assets/trans4.jpeg",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
