import 'dart:convert';

import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:cvault/util/http.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier to fetch dealers or fetch all dealers
///
/// Also used to change the active status of a particular dealer
class DealersProvider extends LoadStatusNotifier {
  DealersProvider() {
    fetchAndSetDealers('');
  }
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
        {'UID': dealerId},
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('dealer/changeActive:${response.statusCode}');
    }
  }

  /// Fetches all dealers
  Future<void> fetchAndSetDealers(String token) async {
    String userType = (await SharedPreferences.getInstance())
        .get(SharedPreferencesKeys.userTypeKey)
        .toString();
    if (page == 1) {
      _dealers = [];
      pageData = {};
      notifyListeners();
    }

    if (userType != 'admin') {
      return;
    }
    correctPageNumber();

    final response = await http.get(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/dealer/getAllDealer?page=$page",
      ),
      headers: defaultAuthenticatedHeader(token),
    );

    if (response.statusCode == 200) {
      List<Dealer> dealers = [];

      final data = jsonDecode(response.body);
      for (var dt in data['docs']) {
        dealers.add(
          Dealer.fromJson('dealer', dt),
        );
      }

      pageData[page] = dealers;

      _dealers.addAll(dealers);
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }
  }
}
