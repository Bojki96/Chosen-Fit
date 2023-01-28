import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// https://stackoverflow.com/questions/65020651/cant-find-proguard-rules-pro-in-my-flutter-app
// https://medium.com/@swav.kulinski/flutter-and-android-obfuscation-8768ac544421
// https://github.com/MaikuB/flutter_local_notifications/blob/master/flutter_local_notifications/example/android/app/proguard-rules.pro

class Notifications {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Notifications() {
    _initializeNotifications();
    tz.initializeTimeZones();
    init();
  }
  init() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermissions;
    }
  }

  _requestIOSPermissions() {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions();
  }

  void _initializeNotifications() async {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notify');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    if (payload != null) {
      print('notification payload: $payload');
    }
  }

  Future<void> showDailyAtTime(
      {@required String datum,
      @required String clientName,
      @required bool prehrana,
      @required int i}) async {
    String ime = clientName;
    int godina = int.parse(datum.split('.')[2]);
    int mjesec = int.parse(datum.split('.')[1]);
    int dan = int.parse(datum.split('.')[0]);
    int sati = int.parse(datum.split(' ')[1]);
    int minute = int.parse(datum.split(' ')[2]);
    int id = i + 1;
    int lokalnoVrijeme = DateTime.now().hour;
    int utcVrijeme = tz.TZDateTime.now(tz.UTC).hour;
    List<String> naslovi = [
      'Hej $ime!',
      'Bok $ime!',
      'Kako si $ime?',
    ];
    List<String> opisi = [
      'Nemoj zaboraviti popiti vode!',
      'Popij čašu vode!',
      'Povećaj svoj dnevni unos vode s jednom čašom vode!',
    ];
    if (prehrana) {
      id = id * 100;
      opisi = [
        'Nemoj zaboraviti pojesti svoj obrok!',
        'Pazi na prehranu, pripremi si obrok i navali!',
        'Pravilna ishrana je bitna za željene rezultate, ne zaboravi jesti!'
      ];
    }
    int vremenskaRazlika = lokalnoVrijeme - utcVrijeme;
    sati -= vremenskaRazlika;
    var scheduledNotification =
        tz.TZDateTime.utc(godina, mjesec, dan, sati, minute);

    int random1 = Random().nextInt(3);
    int random2 = Random().nextInt(3);
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'KanalID', 'ImeKanala',
        styleInformation: BigTextStyleInformation(''),
        color: Color.fromARGB(255, 95, 60, 146),
        largeIcon: DrawableResourceAndroidBitmap('slaven'),
        enableLights: true,
        ledColor: Color.fromARGB(255, 95, 60, 146),
        ledOnMs: 1000,
        ledOffMs: 1000,
        importance: Importance.max,
        priority: Priority.high);
    final iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentBadge: true,
    );
    final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.zonedSchedule(id, naslovi[random1],
        opisi[random2], scheduledNotification, platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<List<PendingNotificationRequest>> getScheduledNotifications() async {
    final pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  Future<List<ActiveNotification>> getActiveNotifications() async {
    final activeNotifications = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();
    return activeNotifications;
  }

  Future cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
