import 'dart:convert';

import 'package:cvault/models/profile_models/customer.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:http/http.dart' as http;

///
class CustomerProvider extends LoadStatusNotifier {
  /// @suraj96506 document this
  bool isBack = false;

  List<Customer> _customers = [];

  ///
  bool get isLoadedCustomers {
    return _customers.isNotEmpty;
  }

  ///
  List<Customer> get customers {
    return [..._customers];
  }

  /// fetch all customers

  /// Fetches specific customers
  Future<void> fetchAndSetCustomers(String token) async {
    if (page == 1) {
      _customers = [];
    }
    final response = await http.get(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/dealer/getDealerCustomer?page=$page",
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
      _customers = temp;
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }
  }
}
