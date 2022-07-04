import 'package:cvault/providers/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Generic Class which has a [loadStatus]
abstract class LoadStatusNotifier extends ChangeNotifier {
  ///
  LoadStatus loadStatus = LoadStatus.initial;

  /// Page number to maintain for pagination
  int page = 1;

  void incrementPage() {
    page += 1;
    notifyListeners();
  }

  Map<int, dynamic> pageData = {};

  void changePage(int newPage) {
    page = newPage;
    notifyListeners();
  }

  /// Corrects the page number for consistency.
  ///
  /// For example, if an API call is made for page=1 then for page=5, this will change it to page=2,
  /// assuring a linear increment in page,
  void correctPageNumber() {
    if (page == 1) {
      return;
    }
    if (!pageData.containsKey(page) && pageData.keys.isNotEmpty) {
      changePage(pageData.keys.last + 1);
    }
  }
}
