import 'package:chosen/notifications.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Controllers {
  static listOfControllers() {
    Map controller = {};
    for (int i = 0; i < 11; i++) {
      controller['kontroler$i'] = TextEditingController();
    }
    return controller;
  }

  static controllerList(int length) {
    Map controller = {};
    for (int i = 0; i < length; i++) {
      controller['kontroler$i'] = TextEditingController();
    }
    return controller;
  }
}

class DateCalculation {
  static String calculateWeekDates(
      {@required DateTime dateNow, @required bool upload}) {
    int danas = dateNow.weekday;
    DateTime nedjelja = DateTime.now();
    DateFormat datumUString = DateFormat("d.M.yyyy.");

    int razlika = 7 - danas;
    nedjelja = nedjelja.add(Duration(days: razlika));

    String nedjeljaDatum;
    if (upload) {
      nedjeljaDatum = datumUString.format(nedjelja);
      return nedjeljaDatum;
    } else {
      String ponedjeljakDatum;
      DateTime ponedjeljak = nedjelja.add(const Duration(days: -6));
      DateFormat formatDate = DateFormat("dd/MM/yyyy");
      ponedjeljakDatum = formatDate.format(ponedjeljak);
      nedjeljaDatum = formatDate.format(nedjelja);
      return '$ponedjeljakDatum - $nedjeljaDatum';
    }
  }
}

class ShowWaterNotifications {
  Notifications _notifications = Notifications();
  DateFormat datumUBazu = DateFormat("d.M.yyyy. H");
  DateFormat formatDate = DateFormat("yyyy-MM-dd");
  List<int> sati = [10, 13, 16, 19];
  String notifikacija;
  DateTime datum = DateTime.now();
  notificationsDateTime({@required String name}) async {
    List nadolazeceNotifikacije =
        await _notifications.getScheduledNotifications();
    List datesToday = [];
    if (nadolazeceNotifikacije.isEmpty) {
      for (int dani = 1; dani < 2; dani++) {
        for (int sat = 0; sat < sati.length; sat++) {
          int month = datum.add(Duration(days: dani)).month;
          int day = datum.add(Duration(days: dani)).day;
          DateTime naredniDani = DateTime(2021, month, day, sati[sat]);
          notifikacija = datumUBazu.format(naredniDani);
          datesToday.add(notifikacija);
        }
      }
    }
    return datesToday;
  }
}

class ShowMealNotifications {
  Notifications _notifications = Notifications();
  DateFormat datumUBazu = DateFormat("d.M.yyyy. H");
  DateFormat formatDate = DateFormat("yyyy-MM-dd");
  List<int> sati = [9, 12, 15, 18];
  String notifikacija;
  DateTime datum = DateTime.now();
  notificationsDateTime({@required String name}) async {
    List nadolazeceNotifikacije =
        await _notifications.getScheduledNotifications();
    List datesToday = [];
    if (nadolazeceNotifikacije.isEmpty) {
      for (int dani = 1; dani < 2; dani++) {
        for (int sat = 0; sat < sati.length; sat++) {
          int month = datum.add(Duration(days: dani)).month;
          int day = datum.add(Duration(days: dani)).day;
          DateTime naredniDani = DateTime(2021, month, day, sati[sat]);
          notifikacija = datumUBazu.format(naredniDani);
          datesToday.add(notifikacija);
        }
      }
    }
    return datesToday;
  }
}

class SetWaterNotifications {
  static setWaterNotifications(
      {@required List<String> sati, @required DateTime datum}) async {
    DateFormat danasnjiDatum = DateFormat("d.M.yyyy.");
    String getDatum = danasnjiDatum.format(datum);
    List<String> datumi = [];
    int hour;
    int minute;
    for (int i = 0; i < sati.length; i++) {
      hour = int.parse(sati[i].split(':')[0]);
      minute = int.parse(sati[i].split(':')[1]);
      datumi.add('$getDatum ${hour} $minute');
    }

    return datumi;
  }
}

class AverageWeight {
  static calculateAverage({@required List weight, @required List dates}) {
    DateFormat formatDate = DateFormat("d.M.yyyy.");
    DateTime date;
    List<DateTime> listaDatuma = [];
    double average = 0;
    List weekLoss = [];
    int razlikaUdanima = 0;
    double brojTjedana = 0;
    for (int i = 0; i < weight.length - 1; i++) {
      average = weight[i + 1] - weight[i];
      weekLoss.add(average);
    }
    for (int i = 0; i < dates.length; i++) {
      date = formatDate.parse(dates[i]);
      listaDatuma.add(date);
    }
    for (int i = 0; i < listaDatuma.length - 1; i++) {
      razlikaUdanima += listaDatuma[i + 1].difference(listaDatuma[i]).inDays;
    }
    brojTjedana = razlikaUdanima / 7;
    average = weekLoss.reduce((value, element) => value + element);
    average /= brojTjedana;
    return average;
  }
}
