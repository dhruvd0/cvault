import 'dart:convert';
import 'dart:io';

import 'package:cvault/models/NonAcceptDealer.dart';
import 'package:cvault/models/profile_models/dealer.dart';
import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

import 'package:cvault/util/http.dart';
import 'package:cvault/util/sharedPreferences/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier to fetch dealers or fetch all dealers
///
/// Also used to change the active status of a particular dealer
class DealersProvider extends LoadStatusNotifier {
  DealersProvider() {
    fetchAndSetDealers('');
  }
  //fetchdealers
  List<Dealer> _dealers = [];
  String? stringRespone;
  //non accept dealer
  List<nonAcceptdealer> listData = [];
  List<nonAcceptdealer> _Data = [];
  //bool activeDealer = true;
  bool toggle = true;

  ///
  List<nonAcceptdealer> tempnonAccept = [];
  List<Dealer> allDealer = [];
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
      //activeDealer = false;
      notifyListeners();
      return true;
    } else {
      throw Exception('dealer/changeActive:${response.statusCode}');
    }
  }

  /// Fetches all dealers
  // ignore: long-method
  Future<void> fetchAndSetDealers(String token) async {
    String userType = (await SharedPreferences.getInstance())
        .get(SharedPreferencesKeys.userTypeKey)
        .toString();
    if (page == 1) {
      _dealers = [];
      pageData = {};
      notifyListeners();
    }

    final response = await http.get(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/dealer/getAllDealer?page=$page",
      ),
      headers: defaultAuthenticatedHeader(token),
    );

    if (response.statusCode == 200) {
      List<Dealer> dealers = [];

      final data = jsonDecode(response.body);
      dealers.clear();
      allDealer.clear();
      for (var dt in data['docs']) {
        dealers.add(
          Dealer.fromJson('dealer', dt),
        );
      }

      pageData[page] = dealers;

      _dealers.addAll(dealers);

      notifyListeners();

      allDealer.addAll(dealers.where((element) =>
          element.phone == FirebaseAuth.instance.currentUser!.phoneNumber));
      print(allDealer.length.toString() + "alldealers");
      if (allDealer.isNotEmpty) {
        print(allDealer[0].active);
      }
      notifyListeners();

      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }

    notifyListeners();
  }

  Future<List<nonAcceptdealer>> getNonAcceptDealer() async {
    http.Response response;
    response = await http.get(Uri.parse(
      "https://cvault-backend.herokuapp.com/admin/nonAcceptedDealers",
    ));
    if (response.statusCode == 200) {
      stringRespone = response.body;
      var mapResponse = jsonDecode(response.body);
      listData.clear();
      tempnonAccept.clear();
      for (var e in mapResponse) {
        nonAcceptdealer model = nonAcceptdealer.fromJson(e);
        listData.add(model);
        tempnonAccept.addAll(
          listData.where(
            (element) =>
                element.phone == FirebaseAuth.instance.currentUser!.phoneNumber,
          ),
        );
        print(listData.length.toString() + "nonlist");
        print(tempnonAccept.length.toString() + "temp");
        notifyListeners();
      }
    }

    notifyListeners();
    return listData;
  }

  Future acceptDealer(token, id) async {
    http.Response response;
    response = await http.post(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/admin/acceptDealer",
      ),
      headers: {
        "Authorization": 'Bearer ${token}',
      },
      body: {
        "dealerId": id,
      },
    );
    notifyListeners();
    print(response.body);
  }

  Future deleteDealer(token, id) async {
    http.Response response;
    response = await http.delete(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/dealer/deleteDealer",
      ),
      headers: {
        "Authorization": 'Bearer ${token}',
      },
      body: {
        "id": id,
      },
    );
    notifyListeners();
    print(response.body);
  }
}
