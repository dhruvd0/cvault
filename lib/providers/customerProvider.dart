
import 'package:cvault/models/customerAdd.dart';
import 'package:cvault/models/profile_models/customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DataClass extends ChangeNotifier {
  bool loading = false;
  bool isBack = false;
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
}
