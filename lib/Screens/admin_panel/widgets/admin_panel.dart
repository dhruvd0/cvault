import 'package:cvault/Screens/admin_panel/widgets/admin_panel_grid.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/Screens/transactions/widgets/transactions_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:cvault/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/customer_management/customer_management.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E2224),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Administration Panel",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (builder) => const HomePage()),
            );
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Consumer<ProfileChangeNotifier>(
          builder: (context, profileNotifier, _) {
            var userType = profileNotifier.profile.userType;

            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TransactionsPage(),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        const Text(
                          "View Transactions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 150,
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(4, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 1.5,
                              color: const Color.fromARGB(255, 165, 231, 243),
                            ),
                          ),
                          child: Image.asset(
                            "assets/money.png",
                            scale: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: userType == UserTypes.admin ? 10 : 30),
                  userType == UserTypes.admin
                      ? const AdminPanelGrid()
                      : GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerManagementPage(),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Customer\nManagement",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(25),
                                height: 150,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 1.5,
                                    color: const Color.fromARGB(
                                      255,
                                      165,
                                      231,
                                      243,
                                    ),
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/user.png",
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
