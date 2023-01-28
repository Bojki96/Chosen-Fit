import 'package:flutter/material.dart';

class DailyUpdateInput with ChangeNotifier {
  List meals = [];
  String waterIntake;
  String weight;
  List mealNumber = ['peti', 'šesti', 'sedmi', 'osmi', 'deveti', 'deseti'];

  Map _dailyUpdate;
  List _meals;
  List _mealNumber = ['prvi', 'drugi', 'treći', 'četvrti'];
  String _waterIntake;
  String _weight = '';
  bool _mealAddedAfterWhile = false;
  Map get getDailyUpdate => _dailyUpdate;
  List get getMeals => _meals;
  String get getWaterIntake => _waterIntake;
  String get getWeight => _weight;
  List get getMealNumber => _mealNumber;
  bool get getMealAddedAfterWhile => _mealAddedAfterWhile;

  void setDailyData(DailyUpdateInput dailyInput) {
    _dailyUpdate = {
      'WaterIntake': dailyInput.waterIntake,
      'Meals': dailyInput.meals
    };
    notifyListeners();
  }

  void setMeals(List meals) {
    _meals = meals;
    notifyListeners();
  }

  void setWaterIntake(String waterIntake) {
    _waterIntake = waterIntake;
    notifyListeners();
  }

  void setWeight(String weight) {
    _weight = weight;
    notifyListeners();
  }

  void addMeal(int currentNumber) {
    if (currentNumber < 10) {
      _mealNumber.add(mealNumber[currentNumber - 4]);
    }
    notifyListeners();
  }

  void mealAddedAfterWhile(bool added) {
    _mealAddedAfterWhile = added;
    notifyListeners();
  }

  void resetMealNumber() {
    _mealNumber = ['prvi', 'drugi', 'treći', 'četvrti'];
    notifyListeners();
  }
}
