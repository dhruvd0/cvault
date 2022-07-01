import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/Screens/admin_panel/pages/customer_management/customer_tile.dart';
import 'package:cvault/providers/customer_provider.dart';
import 'package:cvault/providers/profile_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../home_page.dart';

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
      _scrollController.addListener(() {
        if (!_scrollController.hasClients) {
          return;
        }
        final provider = Provider.of<CustomerProvider>(context, listen: false);
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
    final jswtokcen = Provider.of<ProfileChangeNotifier>(context).token;
    final customerProvider = Provider.of<CustomerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
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
        child: Container(
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
                    : FutureBuilder(
                        future:
                            customerProvider.fetchAndSetCustomers(jswtokcen),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                            case ConnectionState.active:
                            case ConnectionState.waiting:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case ConnectionState.done:
                              if (snapshot.hasError) {
                                return const Text("Try again");
                              }
                              return _buildListView(
                                customerProvider.customers,
                              );
                          }
                        },
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
        ),
      ),
    );
  }
}
