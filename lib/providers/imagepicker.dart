import 'dart:io';
import 'package:flutter/material.dart';

class ChooseImage with ChangeNotifier {
  final List<File> _images = [null, null, null];
  bool _containsNull = false;
  get getImages => _images;
  get getImageNull => _containsNull;
  void setImages(List<File> images) {
    for (int i = 0; i < images.length; i++) {
      if (images[i] == null) {
        continue;
      } else {
        _images[i] = images[i];
      }
    }
    notifyListeners();
  }

  void containsNull(bool containsNUll) {
    _containsNull = containsNUll;
    notifyListeners();
  }
}
