import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

class NotificationProvider extends ChangeNotifier {
  List transactions = [];

  Future<List> getAllNotification(token) async {
    List _transactions = [];

    //String token =
    //"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MmIyZjA3ZmU5Y2IwZTFkNGM0OTU1MTkiLCJpYXQiOjE2NjAwNTU2MTh9.6s46-W-tUFRRupWbMMWIkY6bXjBgdKM_ObrkqZ-bHlg";
    Map<String, String>? header = {
      "Authorization": 'Bearer ${token}',
    };
    final response = await http.get(
      Uri.parse(
          "https://cvault-backend.herokuapp.com/notification/getAllNotifications?page=1"),
      headers: header,
    );
    if (response.statusCode == 200) {
      _transactions = _parseTransactionsFromJsonData(response);

      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }

    notifyListeners();
    return _transactions;
  }

  List _parseTransactionsFromJsonData(
    http.Response response,
  ) {
    var body = jsonDecode(response.body);
    List transactions = body is Map ? body['docs'] : body;

    return transactions;
  }

// ignore: long-parameter-list

  Future<void> updateNotifiaction(token,id, ) async {
    
    Map<String, String>? header = {
      "Authorization": 'Bearer $token',
    };
    final response = await http.patch(
      Uri.parse(
          "https://cvault-backend.herokuapp.com/transaction/changeStatus"),
      headers: header,
      body: {
        "transID": id,
        "status": "accepted",
      },
    );
    print(response.body);
  }

  Future<void> DeleteNotification(token, id) async {
    final response = await http.delete(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/transaction/deleteTrans",
      ),
      headers: {
        "Authorization": 'Bearer $token',
      },
      body: {
        "transID": id,
      },
    );
    print(response.body);
  }
}
