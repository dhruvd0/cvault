// To parse this JSON data, do
//
//     final addModel = addModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class AddModel {
  AddModel({
    required this.id,
    required this.link,
    required this.date,
    required this.v,
  });

  final String id;
  final String link;
  final DateTime date;
  final int v;

  factory AddModel.fromRawJson(String str) =>
      AddModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AddModel.fromJson(Map<String, dynamic> json) => AddModel(
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
