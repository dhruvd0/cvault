
import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/util/http.dart';

import 'dart:convert';

import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:http/http.dart' as http;

class MarginsNotifier extends LoadStatusNotifier {
  double adminMargin = 0;
  double dealerMargin = 0;
  double localeMargin = 0;
  final ProfileChangeNotifier profileChangeNotifier;
  MarginsNotifier(this.profileChangeNotifier) {
    profileChangeNotifier.addListener(() {
      if (profileChangeNotifier.loadStatus == LoadStatus.done &&
          profileChangeNotifier.token.isNotEmpty &&
          profileChangeNotifier.authInstance.currentUser != null) {
        getAllMargins();
      }
    });
  }
  double totalMargin = 0;
  void getTotalMargin() {
    var userType = profileChangeNotifier.profile.userType;
    totalMargin = userType == 'admin'
        ? 0.0
        : userType == 'dealer'
            ? adminMargin.toDouble()
            : (adminMargin + dealerMargin).toDouble();

    notifyListeners();
  }

  double get margin => profileChangeNotifier.profile.userType == 'admin'
      ? adminMargin
      : dealerMargin;
  Future<bool> setMargin(double margin) async {
    var defaultAuthenticatedHeader2 =
        defaultAuthenticatedHeader(profileChangeNotifier.token);
    var user =
        profileChangeNotifier.profile.userType == 'admin' ? '' : 'Dealer';
    if (profileChangeNotifier.profile.userType == 'admin') {
      adminMargin = margin;
    } else {
      dealerMargin = margin;
    }
    notifyListeners();
    final response = await http.post(
      Uri.parse(
        "$baseCvaultUrl/${profileChangeNotifier.profile.userType}/set${user}Margin",
      ),
      headers: defaultAuthenticatedHeader2,
      body: jsonEncode(
        {
          'margin': margin,
        },
      ),
    );
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('setMargin:${response.statusCode}');
  }

  /// IF dealer code is non null them this gets that dealers margin
  Future<void> getMargin(String userType, {String? dealerCode}) async {
    var user = userType == 'admin' ? '' : 'Dealer';
    var uri = Uri.parse(
      "$baseCvaultUrl/$userType/get${user}Margin",
    );
    var header = defaultAuthenticatedHeader(profileChangeNotifier.token);
    final response = dealerCode != null
        ? await http.post(
            uri,
            headers: header,
            body: jsonEncode(
              {
                'referal': dealerCode,
              },
            ),
          )
        : await http.get(
            uri,
          );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (userType == 'admin') {
        adminMargin = data['margin'].toDouble();
      } else {
        dealerMargin = data['margin'].toDouble();
      }

      notifyListeners();

      return;
    }
  }

  Future<void> getAllMargins() async {
    await Future.wait([
      getMargin('admin'),
      getMargin(
        'dealer',
        dealerCode: profileChangeNotifier.profile.referalCode,
      ),
    ]);

    getTotalMargin();
  }
}
