import 'package:cvault/Screens/admin_panel/pages/dealer_management/dealer_tile.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/dealers_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DealerManagementPage extends StatelessWidget {
  const DealerManagementPage({Key? key}) : super(key: key);

  Widget _buildListView(List<Dealer> dealers) {
    return ListView.builder(
      itemCount: dealers.length,
      itemBuilder: (BuildContext context, int index) {
        return DealerTile(dealer: dealers[index]);
      },
    );
  }

  void _onRefresh(context) async {
    // monitor network fetch
    Provider.of<DealersProvider>(context, listen: false).fetchAndSetDealers();
  }

  @override
  Widget build(BuildContext context) {
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
          "Dealer Management",
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
        child: Consumer<DealersProvider>(
          builder: (context, dealerProvider, __) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
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
                      label: const Text(
                        'Invite Dealer',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: (dealerProvider.isDealersLoaded)
                        ? _buildListView(dealerProvider.dealers)
                        : FutureBuilder(
                            future: dealerProvider.fetchAndSetDealers(),
                            builder: (context, snapshot) {
                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xff03dac6),
                                    ),
                                  );
                                case ConnectionState.done:
                                  if (snapshot.hasError) {
                                    return const Center(
                                      child: Text(
                                        "An error has occurred!",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    );
                                  }

                                  return _buildListView(dealerProvider.dealers);
                              }
                            },
                          ),
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
                        /// TODO: Toggle all
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
