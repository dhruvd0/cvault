import 'dart:convert';
import 'dart:developer';

import 'package:cvault/models/profile_models/customer.dart';
import 'package:http/http.dart' as http;

Future register(Customer data) async {
  http.Response? response;
  try {
    response = await http.post(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/customer/create-customer",
      ),
      body: jsonEncode(data.toJson()),
    );
  } catch (e) {
    log(e.toString());
  }
  return response;
}
