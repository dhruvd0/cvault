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

  Future<bool> changeDealerActiveState(String dealerId) async {
    final response = await http.post(
      Uri.parse("https://cvault-backend.herokuapp.com/dealer/changeActive/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {'dealerId': dealerId},
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('dealer/changeActive:' + response.statusCode.toString());
    }
  }

  Future<void> fetchAndSetDealers() async {
    try {
      final response = await http.get(
        Uri.parse("https://cvault-backend.herokuapp.com/dealer/getAllDealer"),
      );

      if (response.statusCode == 200) {
        List<Dealer> dealers = [];

        final List<dynamic> data = jsonDecode(response.body);
        data.forEach(
          (dt) {
            dealers.add(
              Dealer.fromJson('dealer', dt),
            );
          },
        );

        _dealers = dealers;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error, stacktrace) {
      print(error);
      print(stacktrace);
      rethrow;
    }
  }
}