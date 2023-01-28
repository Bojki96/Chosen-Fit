import 'package:flutter/material.dart';

class Loading with ChangeNotifier {
  bool _loadingWidget = false;

  get getloadingWidget => _loadingWidget;

  void setLoadingWidget(bool loading) {
    _loadingWidget = loading;
    notifyListeners();
  }
}
