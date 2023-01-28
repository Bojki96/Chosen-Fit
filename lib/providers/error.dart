import 'package:flutter/material.dart';

class ErrorText with ChangeNotifier {
  String _emailError;
  String _passwordError;
  String _emailErrorLogin;
  String _passErrorLogin;
  bool _errorNotVerified = false;

  get getErrorEmail => _emailError;
  get getErrorPassword => _passwordError;
  get getErrorEmailLogin => _emailErrorLogin;
  get getErrorPassLogin => _passErrorLogin;
  get getErrorNotVerified => _errorNotVerified;

  void setErrorEmail(String error, bool register) {
    if (register) {
      _emailError = error;
    } else {
      _emailErrorLogin = error;
    }
    notifyListeners();
  }

  void removeErrorEmail() {
    _emailError = null;
    _emailErrorLogin = null;
    notifyListeners();
  }

  void setErrorPass(String error, bool register) {
    if (register) {
      _passwordError = error;
    } else {
      _passErrorLogin = error;
    }
    notifyListeners();
  }

  void setErrorNotVerified(bool error) {
    _errorNotVerified = error;
    notifyListeners();
  }

  void removeErrorPass() {
    _passwordError = null;
    _passErrorLogin = null;
    notifyListeners();
  }
}
