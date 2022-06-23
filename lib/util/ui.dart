import 'package:flutter/material.dart';

void showSnackBar(String text, BuildContext context) {
  final snackBar = SnackBar(content: Text(text));

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
