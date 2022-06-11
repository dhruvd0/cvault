import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ExchangeProvider extends ChangeNotifier {
  ExchangeProvider() {
    fetchExchangeRate();
  }

  double _usdToInrRate = 1.0;

  double get usdToInrRate {
    return _usdToInrRate;
  }

  Future<void> fetchExchangeRate() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://openexchangerates.org/api/latest.json?app_id=9a521d92799d41be86ea3f8a571567a4",
        ),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        _usdToInrRate = responseBody["rates"]["INR"];
        notifyListeners();
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error) {
      rethrow;
    }
  }
}
