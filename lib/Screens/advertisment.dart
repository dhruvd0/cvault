import 'package:cvault/providers/getadd.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<advertismentProvider>(context);

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
                  provider.postAdd(string);
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
