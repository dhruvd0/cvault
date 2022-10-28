import 'dart:convert';

import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

///
class CustomerProvider extends LoadStatusNotifier {
  final ProfileChangeNotifier profileChangeNotifier;

  CustomerProvider(this.profileChangeNotifier) {
    profileChangeNotifier.addListener(() async {
      if (profileChangeNotifier.loadStatus == LoadStatus.done &&
          profileChangeNotifier.token.isNotEmpty) {
        changePage(1);
        await fetchAndSetCustomers(profileChangeNotifier.token);
      } else {
        _customers = [];
        pageData = {};
        notifyListeners();
      }
    });
  }

  /// @suraj96506 document this
  bool isBack = false;

  List<Customer> _customers = [];

  ///
  bool getcustomer = false;
  bool get isLoadedCustomers {
    return _customers.isNotEmpty;
  }

  ///
  List<Customer> get customers {
    return [..._customers];
  }

  /// fetch all customers

  /// Fetches specific customers
  // ignore: long-method
  Future<void> fetchAndSetCustomers(String token) async {
    String userType = (await SharedPreferences.getInstance())
        .get(SharedPreferencesKeys.userTypeKey)
        .toString();
    if (page == 1) {
      _customers = [];
      pageData = {};
      notifyListeners();
    }
    String path = '';
    if (userType == 'admin') {
      path = "customer/getAllCustomer";
    } else if (userType == 'dealer') {
      path = "dealer/getDealerCustomer";
    } else {
      return;
    }
    correctPageNumber();

    final response = await http.get(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/$path?page=$page",
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Customer> temp = [];
      (data is Map ? data['docs'] : data).forEach(
        (element) => temp.add(
          Customer.fromJson(element),
        ),
      );
      pageData[page] = temp;

      _customers.addAll(temp);
      notifyListeners();
      getcustomer = true;
      //print(temp.toString() + "hey");
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }
  }
}
