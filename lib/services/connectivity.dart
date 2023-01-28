import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

Connectivity _connectivity = Connectivity();
bool _isOnline = false;

class Connection {
  static initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (result == ConnectivityResult.none) {
      _isOnline = false;
    } else {
      _isOnline = true;
    }
    return _isOnline;
  }
}
