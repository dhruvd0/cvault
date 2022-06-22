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

  /// Fetches all customers
  Future<void> fetchAndSetCustomers() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://cvault-backend.herokuapp.com/dealer/getDealerCustomer",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Customer> temp = [];
        data["data"].forEach(
          (element) => temp.add(
            Customer.fromJson(element),
          ),
        );
        _customers = temp;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }
}
