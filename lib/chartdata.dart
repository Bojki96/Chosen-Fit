import 'package:chosen/functions.dart';
import 'package:chosen/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeightInput {
  String date;
  double weight;

  WeightInput({this.date, this.weight});
}

class WeightData {
  static getWeightData({@required String id}) async {
    List datesAndWeight = await Database.getWeightData(id: id);
    double average = 0;
    double max = 0;
    double min = 0;
    String dateMax = '';
    String dateMin = '';
    String firstDate = '';
    double firstKg = 0;
    Map averageAndChartData = {};
    List<WeightInput> chartData = [];
    DateFormat formatDate = DateFormat("d.M.yyyy.");
    DateFormat datumUString = DateFormat("d.M.");
    DateTime date;
    if (datesAndWeight.isNotEmpty) {
      List dates = datesAndWeight[0];
      List weight = datesAndWeight[1];

      if (dates.length > 1) {
        max = weight.reduce((curr, next) => curr > next ? curr : next);
        min = weight
            .reduce((value, element) => value < element ? value : element);
        average = AverageWeight.calculateAverage(weight: weight, dates: dates);

        int maxIndex = weight.lastIndexOf(max);
        dateMax = dates[maxIndex];

        int minIndex = weight.lastIndexOf(min);
        dateMin = dates[minIndex];
      } else {
        max = weight[0];
      }

      firstDate = dates[0];
      firstKg = weight[0];

      for (int i = 0; i < dates.length; i++) {
        date = formatDate.parse(dates[i]);
        String datumBezGodine = datumUString.format(date);
        chartData.add(WeightInput(date: datumBezGodine, weight: weight[i]));
      }
    }

    averageAndChartData = {
      'average': average,
      'chart': chartData,
      'max': max,
      'min': min,
      'dateMax': dateMax,
      'dateMin': dateMin,
      'firstDate': firstDate,
      'firstKg': firstKg
    };

    return averageAndChartData;
  }
}
