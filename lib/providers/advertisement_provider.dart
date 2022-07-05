import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/profile_models/get_advertisement_model.dart';

/// Get Advertisement
class AdvertisementProvider extends ChangeNotifier {
  late SharedPreferences preferences;
  List<AdModel> listData = [];
  String? imageLink;
  bool? loading;
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
        loading = false;
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
    notifyListeners();
    // ignore: newline-before-return
    return postAdModel;
  }
// delete add

  Future<void> deleteAdd(link) async {
    loading = true;
    PostAdModel? postAdMode;
    http.Response response = await http.delete(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/advertisment/delete-ad",
      ),
      body: {
        "link": link,
      },
    );
  }

  @override
  notifyListeners();

//image picker

  Future<XFile?> pickImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

//image upload to firebase
  Future<String?> uploadImage(XFile image) async {
    Reference deb =
        FirebaseStorage.instance.ref("image Folder/${getImageName(image)}");
    await deb.putFile(File(image.path));
    await deb.getDownloadURL().then((value) {
      setImageLink(value);
      imageLink = value;

      print(imageLink);
    });

    return imageLink;
  }

  //delete image from firebase
  Future<void> DeleteImage(String image) async {
    await FirebaseStorage.instance.refFromURL(image).delete().then((value) {
      removeImageLink();
      imageLink = null;
    });
  }

//image name picker

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  //void _launchUrl() async {
  Future<void> urlLauncher(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  //Sharedprefrences for image link

  Future<void> setImageLink(String link) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("noteData", link);
  }

  Future<void> removeImageLink() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("noteData");
  }
}

//

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
