import 'dart:convert';

import 'package:cvault/models/profile_models/dealer.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

/// Notifier to fetch dealers or fetch all dealers
///
/// Also used to change the active status of a particular dealer
class DealersProvider extends ChangeNotifier {
  List<Dealer> _dealers = [];

  ///
  bool get isDealersLoaded {
    return _dealers.isNotEmpty;
  }

  ///
  List<Dealer> get dealers {
    return [..._dealers];
  }

  /// Changes active state of dealer, [Dealer.active]
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
      throw Exception('dealer/changeActive:${response.statusCode}');
    }
  }

  /// Fetches all dealers
  Future<void> fetchAndSetDealers() async {
    try {
      final response = await http.get(
        Uri.parse("https://cvault-backend.herokuapp.com/dealer/getAllDealer"),
      );

      if (response.statusCode == 200) {
        List<Dealer> dealers = [];

        final List<dynamic> data = jsonDecode(response.body);
        for (var dt in data) {
          dealers.add(
            Dealer.fromJson('dealer', dt),
          );
        }

        _dealers = dealers;
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }
}
