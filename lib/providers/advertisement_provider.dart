import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../models/profile_models/get_advertisement_model.dart';

/// Get Advertisement
class AdvertisementProvider extends ChangeNotifier {
  List<AdModel> listData = [];
  Future<List<AdModel>> getAd() async {
    http.Response response;
    response = await http.get(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/advertisment/get-link",
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> mapResponse = jsonDecode(response.body);
      for (var element in mapResponse) {
        AdModel model = AdModel.fromJson(element);
        listData.add(model);
      }
      notifyListeners();
    }

    return listData;
  }

  /// Post Ad API
  Future<PostAdModel> postAdd(String link) async {
    PostAdModel? postAdModel;
    http.Response response = await http.post(
      Uri.parse(
        'https://cvault-backend.herokuapp.com/advertisment/post-link',
      ),
      body: {
        "link": link,
      },
    );

    var jsonResponse = json.decode(response.body);
    postAdModel = PostAdModel.fromJson(jsonResponse);

    return postAdModel;
  }
}

List<AdModel> addmodelFromJson(String str) =>
    List<AdModel>.from(json.decode(str).map((x) => AdModel.fromJson(x)));

String addmodelToJson(List<AdModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdModel {
  AdModel({
    required this.id,
    required this.link,
    required this.date,
    required this.v,
  });

  String id;
  String link;
  DateTime date;
  int v;

  factory AdModel.fromJson(Map<String, dynamic> json) => AdModel(
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
