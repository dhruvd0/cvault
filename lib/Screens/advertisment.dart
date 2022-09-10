import 'package:cvault/providers/advertisement_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

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

  XFile? singleImage;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdvertisementProvider>(context, listen: true);

    // ignore: newline-before-return
    return Scaffold(
      backgroundColor: const Color(0xff1E2224),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text("Advertisment"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onVerticalDragDown: ((details) async {
          provider.listData;
          setState(() {});
        }),
        child: Container(
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
                  textAlign: TextAlign.center,
                  inputFormatters: const [],
                  onChanged: (string) {
                    provider.addLink = string;
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
              provider.imageLink != null
                  ? Image.network(
                      provider.imageLink.toString(),
                      height: 200,
                    )
                  : const SizedBox.shrink(),
              ElevatedButton(
                onPressed: () async {
                  singleImage = await provider.pickImage();
                  if (singleImage != null && singleImage!.path.isNotEmpty) {
                    provider.uploadImage(singleImage!);
                    setState(() {});
                  }
                },
                child: const Text("Pick Image"),
              ),
              ElevatedButton(
                onPressed: () {
                  print(provider.addLink);
                  if (provider.addLink != null) {
                    provider
                        .postAdd(
                          provider.addLink ?? "",
                          provider.imageLink ?? "",
                        )
                        .then(
                          (value) => ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar),
                        );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('cheack url and image once again'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {},
                      ),
                    ));
                  }

                  setState(() {});
                },
                child: const Text("Upload"),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.deleteAdd(provider.addLink ?? "", singleImage);
                  provider.DeleteImage(provider.imageLink!);

                  setState(() {});
                },
                child: const Text("Remove Add's"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final snackBar = SnackBar(
  content: const Text('successfully upload'),
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () {},
  ),
);
