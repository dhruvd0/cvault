import 'package:cvault/providers/profile_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Generic Class which has a [loadStatus]
abstract class LoadStatusNotifier extends ChangeNotifier {
  ///
  LoadStatus loadStatus = LoadStatus.initial;
}
