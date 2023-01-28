import 'package:chosen/providers/chosencode.dart';
import 'package:chosen/providers/client.dart';
import 'package:chosen/providers/error.dart';
import 'package:chosen/services/auth.dart';
import 'package:chosen/services/database.dart';
import 'package:chosen/services/sharedpreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'loginanimation.dart';

class ChangeData extends StatefulWidget {
  ChangeData({
    Key key,
    this.slaven,
    this.screenHeight,
    this.keyboard,
  }) : super(key: key);

  String slaven;
  double screenHeight;
  double keyboard;
  @override
  State<ChangeData> createState() => _ChangeDataState();
}

class _ChangeDataState extends State<ChangeData>
    with SingleTickerProviderStateMixin {
  AnimationController _editController;

  Client client = Client(name: 'ModelName', lastName: 'ModelLastName');
  pocniAnimaciju() {
    _editController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
  }

  Future animationBack() async {
    await Future.delayed(Duration(milliseconds: 850));
  }

  @override
  void initState() {
    super.initState();
    pocniAnimaciju();
  }

  @override
  void dispose() {
    super.dispose();
    _editController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var slavenProvider = Provider.of<Slaven>(context);
    var error = Provider.of<ErrorText>(context);
    var clientProvider = Provider.of<Client>(context);
    double height = MediaQuery.of(context).size.height;
    var animationForward = Provider.of<Code>(context);

    if (animationForward.getAnimationForward) {
      _editController.forward();
      // animationBack()
      //     .then((value) => animationForward.setAnimationForward(false));
    }
    return SlideTransition(
        position: Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero)
            .animate(_editController),
        child: WillPopScope(
          onWillPop: () async {
            if (animationForward.getAnimationForward) {
              _editController.reverse();
              await Future.delayed(Duration(milliseconds: 850));
              animationForward.setAnimationForward(false);
              return false;
            } else {
              return true;
            }
          },
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
              SafeArea(
                child: Align(
                  alignment: Alignment(
                      MediaQuery.of(context).size.width < 550 ? -1 : 0, -1),
                  child: Container(
                      constraints: BoxConstraints(
                          maxWidth: 500,
                          maxHeight: height < 900 ? height : 900),
                      margin: const EdgeInsets.all(0),
                      child: Scaffold(
                        backgroundColor: Colors.transparent,
                        body: Column(
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
                                          'Promjena podataka',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: fontSize + 5),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                                              change: true,
                                              client: widget.slaven != null
                                                  ? slavenProvider.getSlavenData
                                                  : clientProvider
                                                      .getClientData),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      child: Text(
                                        'Spremi',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize),
                                      ),
                                      onPressed: () async {
                                        if (changeDataKey.currentState
                                            .validate()) {
                                          changeDataKey.currentState.save();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  behavior:
                                                      SnackBarBehavior.fixed,
                                                  content: Text(
                                                      'Izmjena podataka',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))));
                                          client.name = clientData[0];
                                          client.lastName = clientData[1];
                                          client.email = clientData[2];
                                          client.phone = clientData[3];
                                          client.age = clientData[4];
                                          client.height = clientData[5];
                                          client.password = clientData[6];
                                          client.id = FirebaseAuth
                                              .instance.currentUser.uid;
                                          await Auth.reauthenticate();
                                          String errorChangeEmail =
                                              await Auth.updateEmail(
                                                  newEmail: client.email);
                                          String errorChangePass =
                                              await Auth.updatePassword(
                                                  newPassword: client.password);
                                          String unKnownError = '';
                                          if (errorChangeEmail.isNotEmpty) {
                                            unKnownError = errorChangeEmail;
                                          }
                                          if (errorChangePass.isNotEmpty) {
                                            unKnownError = errorChangePass;
                                          }
                                          if (unKnownError.isNotEmpty) {
                                            error.setErrorEmail(
                                                unKnownError, true);
                                          } else {
                                            await _editController.reverse();
                                            widget.slaven != null
                                                ? client.admin = true
                                                : client.admin = false;
                                            await Database.updateClient(
                                                client: client);
                                            await LocalStorage.setAuth(
                                                email: client.email,
                                                password: client.password);
                                            error.setErrorEmail('', true);
                                            widget.slaven != null
                                                ? slavenProvider
                                                    .setSlavenData(client)
                                                : clientProvider
                                                    .setClientData(client);
                                            animationForward
                                                .setAnimationForward(false);
                                          }
                                        }
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Otkaži',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize),
                                      ),
                                      onPressed: () async {
                                        for (int i = 0; i < 9; i++) {
                                          controller['kontroler$i'].value =
                                              controller['kontroler$i']
                                                  .value
                                                  .copyWith(text: '');
                                        }
                                        await _editController.reverse();
                                        animationForward
                                            .setAnimationForward(false);
                                      },
                                    )
                                  ],
                                ),
                              )
                            ]),
                      )),
                ),
              ),
            ],
          ),
        ));
  }
}
