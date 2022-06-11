import 'dart:convert';

import 'package:cvault/models/customer_add.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CustomerProvider extends ChangeNotifier {
  bool loading = false;
  bool isBack = false;

  List<Customer> _customers = [];

  bool get isLoadedCustomers {
    return _customers.isNotEmpty;
  }

  List<Customer> get customers {
    return [..._customers];
  }

  Future<void> postData(Customer body) async {
    loading = true;
    notifyListeners();
    http.Response response = (await register(body))!;
    if (response.statusCode == 200) {
      isBack = true;
    }
    loading = false;
    notifyListeners();
  }

  Future<void> fetchAndSetCustomers() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://cvault-backend.herokuapp.com/customer/getAllCustomer",
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
