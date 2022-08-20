

import 'package:cvault/Screens/admin_panel/widgets/admin_panel_grid.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/Screens/transactions/widgets/transactions_page.dart';
import 'package:cvault/constants/user_types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../home_page.dart';
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
      backgroundColor:  Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 70,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ));
          },
          icon:const Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Color(0xff252836),
        centerTitle: true,
        title: const Text(
          "Administration Panel",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        elevation: 0,
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
                             userType == UserTypes.admin
                      ?  "assets/trans.jpeg":"assets/Card.jpg",
                          fit: BoxFit.fitWidth,
                              
                            ),
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
                                builder: (context) =>
                                    const CustomerManagementPage(),
                              ),
                            );
                          },
                          child: Container(
                             padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                
                                const SizedBox(height: 10),
                                Container(
                                
                                  
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
                                   
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      "assets/Card-2.jpg",
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
