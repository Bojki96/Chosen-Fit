import 'package:chosen/dialog.dart';
import 'package:chosen/loadingdata.dart';
import 'package:chosen/loginanimation.dart';
import 'package:chosen/notifications.dart';
import 'package:chosen/providers/client.dart';
import 'package:chosen/providers/error.dart';
import 'package:chosen/providers/loadingwidget.dart';
import 'package:chosen/services/auth.dart';
import 'package:chosen/services/database.dart';
import 'package:chosen/services/sharedpreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Prijava2 extends StatefulWidget {
  const Prijava2({Key key}) : super(key: key);

  @override
  _Prijava2State createState() => _Prijava2State();
}

double fontSize = 21;

class _Prijava2State extends State<Prijava2> with TickerProviderStateMixin {
  AnimationController _slideController;
  AnimationController _slideRegistration;
  bool visibleLogIn = false;
  bool visibleReg = false;
  bool visibleChoose = true;

  void visibleLog(bool visible) {
    setState(() {
      visibleLogIn = visible;
      visibleChoose = !visible;
    });
  }

  void visibleRegIn(bool visible) {
    setState(() {
      visibleReg = visible;
      visibleChoose = !visible;
    });
  }

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));

    _slideRegistration = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    var loadingWidget = Provider.of<Loading>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(alignment: Alignment.center, children: [
          Container(
            width: width,
            height: height,
            padding: EdgeInsets.only(top: height / 7.2),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 95, 60, 146), Colors.white],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.1, 0.6])),
            child: Visibility(
              visible: height < 600 ? visibleChoose : true,
              maintainAnimation: true,
              maintainState: true,
              child: FadeTransition(
                opacity: Tween(begin: 1.0, end: height < 600 ? 0.0 : 1.0)
                    .animate(_slideController),
                child: Text(
                  'Chosen.fit',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: height / 15,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(color: Colors.white, offset: Offset(1.0, 2.0))
                      ]),
                ),
              ),
            ),
          ),
          Visibility(
            visible: visibleChoose,
            maintainAnimation: true,
            maintainState: true,
            child: FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0).animate(_slideController),
              child: Align(
                alignment: Alignment(0, 0.2),
                child: SizedBox(
                  height: 300,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          'Prijava',
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSize + 7),
                        ),
                        onPressed: () {
                          setState(() {
                            visibleLogIn = true;
                          });
                          _slideController.forward();
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextButton(
                        child: Text(
                          'Registracija',
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSize + 7),
                        ),
                        onPressed: () {
                          setState(() {
                            visibleReg = true;
                          });

                          _slideRegistration.forward();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          LogIn(
            slideController: _slideController,
            height: height,
            keyboard: keyboard,
            visible: visibleLogIn,
          ),
          Registracija(
            slideController: _slideRegistration,
            height: height,
            visible: visibleReg,
            visibleReg: visibleRegIn,
          ),
          loadingWidget.getloadingWidget
              ? LoadingData(
                  text: 'Prijavljivanje',
                )
              : const SizedBox(),
        ]));
  }
}

class Registracija extends StatelessWidget {
  Registracija(
      {Key key,
      @required AnimationController slideController,
      @required this.height,
      @required this.visible,
      @required this.visibleReg})
      : _slideController = slideController,
        super(key: key);
  final Function visibleReg;
  final AnimationController _slideController;
  final double height;
  final bool visible;
  Client client = Client(name: 'ModelName', lastName: 'ModelLastName');

  @override
  Widget build(BuildContext context) {
    double keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Visibility(
      visible: visible,
      maintainState: true,
      maintainAnimation: true,
      child: FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(_slideController),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color.fromARGB(255, 95, 60, 146), Colors.white],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [0.1, 0.6]),
                ),
              ),
              WillPopScope(
                onWillPop: () async {
                  if (visible) {
                    for (int i = 0; i < 9; i++) {
                      controller['kontroler$i'].value =
                          controller['kontroler$i'].value.copyWith(text: '');
                    }
                    await _slideController.reverse();
                    visibleReg(false);
                    return false;
                  } else {
                    return true;
                  }
                },
                child: SafeArea(
                  child: Align(
                    alignment: Alignment(
                        MediaQuery.of(context).size.width > 550 ? 0 : -1, -1),
                    child: Container(
                        constraints: BoxConstraints(
                            maxWidth: 500,
                            maxHeight: height < 1010
                                ? MediaQuery.of(context).size.height
                                : 1010),
                        margin: const EdgeInsets.all(0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment(-1.2, 0),
                                      child: Container(
                                        margin: EdgeInsets.only(top: 30),
                                        alignment: Alignment.center,
                                        width: 280,
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 95, 60, 146),
                                            border: Border.all(
                                                color: Colors.indigo[400],
                                                width: 3.0),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Text(
                                          'Registracija',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fontSize + 9),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 25,
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              45, 0, 30, 0),
                                          child: LogInOrSignUp(
                                              loginOrSignUp: 'registracija',
                                              change: false,
                                              client: null),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  child: Text(
                                    'Registriraj se',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: fontSize),
                                  ),
                                  onPressed: () async {
                                    if (registerKey.currentState.validate()) {
                                      registerKey.currentState.save();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration:
                                                  Duration(milliseconds: 1700),
                                              backgroundColor: Color.fromARGB(
                                                  255, 95, 60, 146),
                                              behavior: SnackBarBehavior.fixed,
                                              content: const Text(
                                                  'Registriranje!',
                                                  style: TextStyle(
                                                      color: Colors.white))));
                                      client.name = clientData[0];
                                      client.lastName = clientData[1];
                                      client.email = clientData[2];
                                      client.phone = clientData[3];
                                      client.age = clientData[4];
                                      client.height = clientData[5];
                                      client.password = clientData[6];
                                      var errorRegistration =
                                          await Auth.newClient(
                                              client: client,
                                              actCode: clientData[8]);
                                      if (errorRegistration is String) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Color.fromARGB(
                                                    255, 95, 60, 146),
                                                behavior:
                                                    SnackBarBehavior.fixed,
                                                content: Text(errorRegistration,
                                                    style: const TextStyle(
                                                        color: Colors.red))));
                                      } else {
                                        await _slideController.reverse();
                                        await Auth.signOut();
                                        visibleReg(false);
                                      }
                                    }
                                  },
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                      side: BorderSide.none,
                                      backgroundColor: Colors.transparent),
                                  child: Text(
                                    'Otkaži',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 95, 60, 146),
                                        fontSize: fontSize),
                                  ),
                                  onPressed: () async {
                                    for (int i = 0; i < 9; i++) {
                                      controller['kontroler$i'].value =
                                          controller['kontroler$i']
                                              .value
                                              .copyWith(text: '');
                                    }

                                    await _slideController.reverse();
                                    visibleReg(false);
                                  },
                                ),
                              )
                            ])),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

class LogIn extends StatelessWidget {
  LogIn({
    Key key,
    @required AnimationController slideController,
    @required this.height,
    @required this.keyboard,
    @required this.visible,
  })  : _slideController = slideController,
        super(key: key);

  final AnimationController _slideController;
  final double height;
  final double keyboard;
  final bool visible;
  int counter = 0;
  Client client = Client(name: 'ModelName', lastName: 'ModelLastName');
  Notifications _notifications = Notifications();
  bool isEmailVerified = false;

  @override
  Widget build(BuildContext context) {
    var errorText = Provider.of<ErrorText>(context);
    var clientProvider = Provider.of<Client>(context);
    var slavenProvider = Provider.of<Slaven>(context);
    var loadingWidget = Provider.of<Loading>(context);
    return Visibility(
      visible: visible,
      maintainState: true,
      maintainAnimation: true,
      child: FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(_slideController),
        child: Align(
          alignment: Alignment(0.0, 280 / height),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            height: 444,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                LimitedBox(
                  maxHeight: 280,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 25, 0, 0),
                      child: LogInOrSignUp(
                        loginOrSignUp: 'prijava',
                        change: false,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    'Prijava',
                    style:
                        TextStyle(color: Colors.white, fontSize: fontSize + 7),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (loginKey.currentState.validate()) {
                      loginKey.currentState.save();
                      loadingWidget.setLoadingWidget(true);
                      var errorLogIn = await Auth.logIn(
                          email: clientData[0], password: clientData[1]);
                      if (errorLogIn is String) {
                        loadingWidget.setLoadingWidget(false);
                        if (errorLogIn ==
                            'Neuspješna prijava, pokušajte ponovno') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(errorLogIn,
                                  style: const TextStyle(color: Colors.red))));
                          errorText.removeErrorEmail();
                          errorText.removeErrorPass();
                        } else if (errorLogIn == 'E-mail ne postoji') {
                          errorText.setErrorEmail(errorLogIn, false);
                          errorText.removeErrorPass();
                        } else {
                          errorText.setErrorPass(errorLogIn, false);
                          errorText.removeErrorEmail();
                        }
                      } else {
                        errorText.removeErrorEmail();
                        errorText.removeErrorPass();
                        isEmailVerified = await Auth.checkEmailVerified();
                        if (isEmailVerified) {
                          client.id = FirebaseAuth.instance.currentUser.uid;
                          Client clientsData =
                              await Database.getClientData(id: client.id);
                          await LocalStorage.setAuth(
                              email: clientData[0], password: clientData[1]);
                          if (clientsData.admin) {
                            slavenProvider.setSlavenData(clientsData);
                            loadingWidget.setLoadingWidget(false);
                            Navigator.pushReplacementNamed(
                              context,
                              '/clients',
                            );
                          } else {
                            loadingWidget.setLoadingWidget(false);
                            await _notifications.cancelAllNotifications();
                            clientProvider.setClientData(clientsData);
                            Navigator.pushReplacementNamed(
                              context,
                              '/profil',
                            );
                          }
                        } else {
                          loadingWidget.setLoadingWidget(false);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              margin: EdgeInsets.all(0),
                              content: Text(
                                  'Trebate verificirati e-mail adresu!',
                                  style: const TextStyle(color: Colors.red))));
                          await Auth.signOut();
                          errorText.setErrorNotVerified(true);
                        }
                      }
                    }
                  },
                ),
                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => DialogChosen(
                                fontSize: fontSize,
                                changeCode: false,
                                forgetPassword: true,
                              ),
                          barrierDismissible: true);
                    },
                    style: TextButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: Colors.transparent),
                    child: Text(
                      'Zaboravili ste lozinku?',
                      style: TextStyle(
                          color: Colors.black, fontSize: fontSize - 6),
                    )),
                errorText.getErrorNotVerified
                    ? TextButton(
                        onPressed: () async {
                          var user = await Auth.logIn(
                              email: clientData[0], password: clientData[1]);
                          if (user is String) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                margin: EdgeInsets.all(0),
                                content: Text(
                                    'Došlo je do greške! Pokušajte ponovo kasnije.',
                                    style:
                                        const TextStyle(color: Colors.red))));
                          } else {
                            await user.sendEmailVerification();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                margin: EdgeInsets.all(0),
                                content: Text(
                                    'Verifikacijski link poslan na email adresu "${clientData[0]}"',
                                    style:
                                        const TextStyle(color: Colors.white))));
                          }
                          await Auth.signOut();
                        },
                        style: TextButton.styleFrom(
                            side: BorderSide.none,
                            backgroundColor: Colors.transparent),
                        child: Text(
                          'Pošalji verifikacijski link ponovo!',
                          style: TextStyle(
                              color: Colors.indigo[800],
                              fontSize: fontSize - 6),
                        ))
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
