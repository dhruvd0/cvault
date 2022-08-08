import 'dart:convert';
import 'dart:html';

import 'package:cvault/models/Notification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationApi extends ChangeNotifier {
  List<NewNotification> listData = [];
  Future GetAllNotification(String token) async {
    Notification model;
    String stringResponse;

    http.Response response;
    response = await http.get(
      Uri.parse(
          "https://cvault-backend.herokuapp.com/notification/getAllNotifications?page=1"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      stringResponse = response.body;
      List<dynamic> mapResponse = jsonDecode(stringResponse);
      for (var e in mapResponse) {
        NewNotification model = NewNotification.fromJson(e);
        listData.add(model);
      }
      print(listData[0].docs![0].email);
      return listData;
    }
    return listData;
  }
}
