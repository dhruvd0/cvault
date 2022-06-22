import 'package:cvault/providers/profile_provider.dart';
import 'package:cvault/util/http.dart';

import 'dart:convert';

import 'package:cvault/providers/common/load_status_notifier.dart';
import 'package:http/http.dart' as http;

class MarginsNotifier extends LoadStatusNotifier {
  double adminMargin = 0;
  double dealerMargin = 0;
  ProfileChangeNotifier profileChangeNotifier;
  MarginsNotifier(this.profileChangeNotifier);

  Future<bool> setMargin(double margin) async {
    var defaultAuthenticatedHeader2 =
        defaultAuthenticatedHeader(profileChangeNotifier.jwtToken);
    var user =
        profileChangeNotifier.profile.userType == 'admin' ? '' : 'Dealer';
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
  Future<void> getMargin({String? dealerCode}) async {
    var user =
        profileChangeNotifier.profile.userType == 'admin' ? '' : 'Dealer';
    var uri = Uri.parse(
      "$baseCvaultUrl/${profileChangeNotifier.profile.userType}/get${user}Margin",
    );
    var header = defaultAuthenticatedHeader(profileChangeNotifier.jwtToken);
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
      if (profileChangeNotifier.profile.userType == 'admin') {
        adminMargin = data['margin'];
      } else {
        dealerMargin = data['margin'];
      }

      notifyListeners();

      return;
    }
    throw Exception('getMargin:${response.statusCode}');
  }
}
