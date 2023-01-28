import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class LocalStorage {
  static SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setWaterDates({@required List<String> dates}) async {
    await _preferences.setStringList('waterDates', dates);
  }

  static Future setMealDates({@required List<String> dates}) async {
    await _preferences.setStringList('mealDates', dates);
  }

  static List<String> getWaterDates() =>
      _preferences.getStringList('waterDates');

  static List<String> getMealDates() => _preferences.getStringList('mealDates');

  static void removeNotifications() async {
    await _preferences.remove('waterDates');
    await _preferences.remove('mealDates');
  }

//REAUTHENTICATE
  static Future setAuth(
      {@required String email, @required String password}) async {
    await _preferences.setStringList('auth', [email, password]);
  }

  static Future getAuth() async {
    return await _preferences.getStringList('auth');
  }
}
