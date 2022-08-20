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
Future<void> addNotification(token,transactionId,FirstName,LastName,Phone,Email,Transactiontype,cryptoType,Price,Quantity,Status)async{
    Map<String, String>? header = {
      "Authorization": 'Bearer $token',
    };
    final response = await http.post(
      Uri.parse(
          "https://cvault-backend.herokuapp.com/notification/addNotification",),
      headers: header,
      body: {
        "transactionId":transactionId,
        "FirstName":FirstName,
        "LastName":LastName,
        "Phone":Phone,
        "Email":Email,
        "Transactiontype":Transactiontype,
        "cryptoType":cryptoType,
        "Price":Price,
        "Quantity":Quantity,
        "Status":Status,
      },
      
    );
}

  Future<void> updateNotifiaction(token,data)async{
     Map<String, String>? header = {
      "Authorization": 'Bearer ${token}',
    };
    final response = await http.post(
      Uri.parse(
          "https://cvault-backend.herokuapp.com/notification/updateNotification/62d13b6786211b819bc902b6"),
      headers: header,
      body: {
        "Status":data,
      },
      
    );
    print(response.body);
  }
}
