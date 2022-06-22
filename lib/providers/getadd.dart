import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../models/profile_models/get_advertisement_model.dart';

class advertismentProvider extends ChangeNotifier {
//getaddapi
  List<Addmodel> listData = [];
  Future<List<Addmodel>> getadd() async {
    http.Response response;
    response = await http.get(Uri.parse(
      "https://cvault-backend.herokuapp.com/advertisment/get-link",
    ));

    if (response.statusCode == 200) {
      String stringRespone = response.body;
      List<dynamic> mapResponse = jsonDecode(response.body);
      for (var element in mapResponse) {
        Addmodel model = Addmodel.fromJson(element);
        listData.add(model);
      }
      notifyListeners();
    }
    return listData;
  }

//postaddapi
  Future<PostAdverModel> postAdd(String link) async {
    PostAdverModel? postAdverModel;
    http.Response response = await http.post(
      Uri.parse(
        'https://cvault-backend.herokuapp.com/advertisment/post-link',
      ),
      body: {
        "link": link,
      },
    );

    var jsonResponse = json.decode(response.body);
    postAdverModel = PostAdverModel.fromJson(jsonResponse);

    return postAdverModel;
  }
}

List<Addmodel> addmodelFromJson(String str) =>
    List<Addmodel>.from(json.decode(str).map((x) => Addmodel.fromJson(x)));

String addmodelToJson(List<Addmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Addmodel {
  Addmodel({
    required this.id,
    required this.link,
    required this.date,
    required this.v,
  });

  String id;
  String link;
  DateTime date;
  int v;

  factory Addmodel.fromJson(Map<String, dynamic> json) => Addmodel(
        id: json["_id"],
        link: json["link"],
        date: DateTime.parse(json["date"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "link": link,
        "date": date.toIso8601String(),
        "__v": v,
      };
}
