import 'dart:async';
import 'package:chosen/clip.dart';
import 'package:chosen/services/auth.dart';
import 'package:chosen/services/connectivity.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key key}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  Timer timer;

  Future connectivity() async {
    return await Connection.initConnectivity();
  }

  @override
  void initState() {
    super.initState();
    Auth.signOut();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      connectivity().then((value) {
        if (value) {
          timer.cancel();
          Navigator.pushReplacementNamed(context, '/prijava2');
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 95, 60, 146),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipPath(
                clipper: SubtitleClipper(),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(15, 15, 35, 15),
                  color: Color.fromARGB(255, 95, 60, 146),
                  child: const Text(
                    'Chosen.fit',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(color: Colors.white, offset: Offset(1.0, 2.0))
                        ]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons
                          .signal_wifi_statusbar_connected_no_internet_4_outlined,
                      color: Colors.white,
                      size: 60,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        'Kako bi aplikacija ispravno funkcionirala, molim Vas da se spojite na internet!',
                        style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
