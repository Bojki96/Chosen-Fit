import 'package:flutter/material.dart';

class Code with ChangeNotifier {
  String _code;
  int _selectedWeek;
  bool _animationForward = false;

  get getActCode => _code;
  get getWeek => _selectedWeek;
  get getAnimationForward => _animationForward;

  void setActCode(String actCode) {
    _code = actCode;
    notifyListeners();
  }

  void setWeek(int selectedWeek) {
    _selectedWeek = selectedWeek;
    notifyListeners();
  }

  void setAnimationForward(bool animate) {
    _animationForward = animate;
    notifyListeners();
  }
}
