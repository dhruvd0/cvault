import 'dart:convert';

import 'package:cvault/models/profile_models/getAdvertisemodel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Advertisment extends StatefulWidget {
  const Advertisment({Key? key}) : super(key: key);

  @override
  State<Advertisment> createState() => _AdvertismentState();
}

class _AdvertismentState extends State<Advertisment> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1E2224),
      appBar: AppBar(
        title: const Text("Advertisment"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                autovalidateMode: AutovalidateMode.always,
                textAlign: TextAlign.center,
                inputFormatters: const [],
                onChanged: (string) {
                  setState(() {
                    postAdd(string);
                  });
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'paste you link',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
