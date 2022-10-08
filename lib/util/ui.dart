import 'package:flutter/material.dart';

void showSnackBar(String text, BuildContext context) {
  final snackBar =
      SnackBar(duration: Duration(seconds: 1), content: Text(text));

  ScaffoldMessenger.of(context).showSnackBar(
    snackBar,
  );
}
