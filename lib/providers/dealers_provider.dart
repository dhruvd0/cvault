import 'dart:convert';

import 'package:cvault/models/profile_models/dealer.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class DealersProvider extends ChangeNotifier {
  List<Dealer> _dealers = [];

  bool get isDealersLoaded {
    return _dealers.isNotEmpty;
  }

  List<Dealer> get dealers {
    return [..._dealers];
  }

  Future<void> fetchAndSetDealers() async {
    try {
      final response = await http.get(
        Uri.parse("https://cvault-backend.herokuapp.com/dealer/getAllDealer"),
      );

      List<Dealer> dealers = [];

      final List<dynamic> data = jsonDecode(response.body);
      data.forEach(
        (dt) {
          dealers.add(
            Dealer.fromJson(dt),
          );
        },
      );

      _dealers = dealers;
      notifyListeners();
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      rethrow;
    }
  }
}
