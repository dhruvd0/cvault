import 'package:cvault/Screens/home/widgets/dashboard_page.dart';
import 'package:cvault/home_page.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/Screens/admin_panel/pages/customer_management/customer_tile.dart';
import 'package:cvault/providers/customer_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerManagementPage extends StatefulWidget {
  const CustomerManagementPage({Key? key}) : super(key: key);

  @override
  State<CustomerManagementPage> createState() => _CustomerManagementPageState();
}

class _CustomerManagementPageState extends State<CustomerManagementPage> {
  final ScrollController _scrollController = ScrollController();

  void _onRefresh(context) async {
    // monitor network fetch
    var provider = Provider.of<CustomerProvider>(
      context,
      listen: false,
    );
    provider.changePage(1);
    await provider.fetchAndSetCustomers(
      Provider.of<ProfileChangeNotifier>(context, listen: false).token,
    );
  }

  Widget _buildListView(List<Customer> customers) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: customers.length,
      itemBuilder: (BuildContext context, int index) {
        return CustomerTile(customer: customers[index]);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<CustomerProvider>(context, listen: false);

      _scrollController.addListener(() {
        if (!_scrollController.hasClients) {
          return;
        }

        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            !(provider.loadStatus == LoadStatus.loading)) {
          provider.incrementPage();
          provider.fetchAndSetCustomers(
            Provider.of<ProfileChangeNotifier>(context, listen: false).token,
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          _onRefresh(context);
        },
        child: Consumer<CustomerProvider>(
          builder: (context, customerProvider, __) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: (customerProvider.isLoadedCustomers)
                        ? _buildListView(customerProvider.customers)
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
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
                      label: const Text(
                        'Toggle All',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
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
                      label: const Text(
                        'Revert All To Admin',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
