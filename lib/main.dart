import 'package:chosen/providers/client.dart';
import 'package:chosen/providers/imagepicker.dart';
import 'package:chosen/providers/loadingwidget.dart';
import 'package:chosen/providers/meals.dart';
import 'package:chosen/providers/chosencode.dart';
import 'package:chosen/providers/error.dart';
import 'package:chosen/screens/chart.dart';
import 'package:chosen/screens/clients.dart';
import 'package:chosen/screens/dailyupdate.dart';
import 'package:chosen/screens/datesdaily.dart';
import 'package:chosen/screens/noconnection.dart';
import 'package:chosen/screens/notificationmaker.dart';
import 'package:chosen/screens/prijava2.dart';
import 'package:chosen/screens/profil.dart';
import 'package:chosen/screens/weeklydates.dart';
import 'package:chosen/screens/weeklyupdate.dart';
import 'package:chosen/services/auth.dart';
import 'package:chosen/services/sharedpreferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocalStorage.init();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarContrastEnforced: true,
      systemNavigationBarColor: Color.fromARGB(255, 95, 60, 146),
      systemNavigationBarDividerColor: Color.fromARGB(255, 95, 60, 146),
      systemNavigationBarIconBrightness: Brightness.light));
  String initialRoute = await Auth.autoLogIn();
  double fontSize = 21;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => ErrorText()),
        ChangeNotifierProvider(
            create: (BuildContext context) => DailyUpdateInput()),
        ChangeNotifierProvider(create: (BuildContext context) => Client()),
        ChangeNotifierProvider(create: (BuildContext context) => Slaven()),
        ChangeNotifierProvider(create: (BuildContext context) => Code()),
        ChangeNotifierProvider(create: (BuildContext context) => ChooseImage()),
        ChangeNotifierProvider(create: (BuildContext context) => Loading()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child),
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 95, 60, 146),
          hoverColor: Color.fromARGB(255, 95, 85, 146),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Color.fromARGB(255, 95, 60, 146),
              selectionColor: Color.fromARGB(255, 95, 60, 146),
              selectionHandleColor: Color.fromARGB(255, 95, 60, 146)),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            contentPadding: const EdgeInsets.all(0),
            floatingLabelStyle:
                TextStyle(fontSize: fontSize - 3, color: Colors.purple[900]),
            hintStyle: TextStyle(fontSize: fontSize),
            labelStyle: const TextStyle(color: Colors.white),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 95, 60, 146)),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 95, 60, 146)),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                    color: Color.fromARGB(255, 95, 60, 146),
                    fontSize: fontSize)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 95, 60, 146)),
                overlayColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 95, 85, 146),
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(),
                ),
                side: MaterialStateProperty.all<BorderSide>(BorderSide(
                  color: Colors.indigo[400],
                  width: 3,
                ))),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: Color.fromARGB(255, 95, 60, 146),
            behavior: SnackBarBehavior.floating,
            shape: const ContinuousRectangleBorder(),
          ),
          timePickerTheme: TimePickerThemeData(
              dialHandColor: Color.fromARGB(255, 95, 60, 146),
              backgroundColor: Colors.white,
              dialBackgroundColor: Colors.white,
              hourMinuteTextColor: Color.fromARGB(255, 95, 60, 146),
              hourMinuteShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple[900])),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple[900])),
                  filled: true,
                  fillColor: Colors.white,
                  focusColor: Colors.white,
                  counterStyle: TextStyle(color: Colors.white))),
        ),
        routes: {
          '/profil': (BuildContext context) => Profil(),
          '/dailyupdate': (BuildContext context) => DailyUpdate(),
          '/weeklyupdate': (BuildContext context) => WeeklyUpdate(),
          '/clients': (BuildContext context) => Clients(),
          '/datesdaily': (BuildContext context) => DailyUpdateDates(),
          '/weeklydates': (BuildContext context) => WeeklyUpdateDates(),
          '/nointernet': (BuildContext context) => NoInternet(),
          '/notificationmaker': (BuildContext context) => NotificationMaker(),
          '/prijava2': (BuildContext context) => Prijava2(),
          '/chart': (BuildContext context) => WeightChart()
        },
        initialRoute: initialRoute,
      ),
    ),
  );
}
