import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cvault/models/profile_models/get_advertisement_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Get Advertisement
class AdvertisementProvider extends ChangeNotifier {
  late SharedPreferences preferences;
  List<AdModel> listData = [];
  String? imageLink;
  bool? loading;
  String? addLink;
  AdvertisementProvider() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      getAd();
      listData;
      print(listData[0].imageLink);
      notifyListeners();
    });
  }

  Future<List> getAd() async {
    http.Response response;
    response = await http.get(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/advertisment/get-link",
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> mapResponse = jsonDecode(response.body);

      for (var e in mapResponse) {
        AdModel model = AdModel.fromJson(e);
        listData.add(model);
      }

      return listData;
    }
    notifyListeners();

    return listData;
  }

  /// Post Ad API
  Future<AdModel> postAdd(String redirectlink, String imagelink) async {
    http.Response response = await http.post(
      Uri.parse(
        'https://cvault-backend.herokuapp.com/advertisment/post-link',
      ),
      body: {
        "redirectLink": redirectlink,
        "imageLink": imageLink,
      },
    );

    var jsonResponse = json.decode(response.body);
    AdModel model = AdModel.fromJson(jsonResponse);
    notifyListeners();
    // ignore: newline-before-return
    return model;
  }
// delete add

  Future<void> deleteAdd(String redirectlink, imagelink) async {
    loading = true;
    AdModel? postAdMode;
    http.Response response = await http.delete(
      Uri.parse(
        "https://cvault-backend.herokuapp.com/advertisment/delete-ad",
      ),
      body: {
        "redirectLink": redirectlink,
        "imageLink": imageLink,
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
  Future<void> urlLauncher(url) async {
    // String url = "https://www.youtube.com/watch?v=R6mA6_GRMZQ";
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      print("cksjxdkjslkjdlkjf;skdl;sk");
    }
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
