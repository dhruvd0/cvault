import 'package:cvault/providers/advertisement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:regexed_validator/regexed_validator.dart';

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
    final provider = Provider.of<AdvertisementProvider>(context, listen: true);
    String addLink = "";
    // ignore: newline-before-return
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
          mainAxisAlignment: MainAxisAlignment.start,
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
                validator: (string) {
                  if (string == null || !validator.url(string)) {
                    return 'Please enter a valid email';
                  }
                  // ignore: newline-before-return
                  return null;
                },
                onChanged: (string1) {
                  provider.postAdd(string1);
                  addLink = string1;
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'paste your link',
                  hintStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                provider.deleteAdd(addLink);
              },
              child: const Text("Remove Add's"),
            ),
            Visibility(
              visible: provider.listData.isEmpty ? false : true,
              child: Container(
                height: MediaQuery.of(context).size.width * 0.50,
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('AD'),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.60,
                      child: Center(
                        child: Image.network(
                          provider.listData.isNotEmpty
                              ? provider.listData[0].link
                              : "",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const Text('AD'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
