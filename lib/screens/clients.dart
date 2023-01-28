import 'dart:async';
import 'package:chosen/changedata.dart';
import 'package:chosen/clip.dart';
import 'package:chosen/dialog.dart';
import 'package:chosen/providers/client.dart';
import 'package:chosen/providers/chosencode.dart';
import 'package:chosen/services/auth.dart';
import 'package:chosen/services/cloudfunctions.dart';
import 'package:chosen/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Clients extends StatelessWidget {
  Clients({Key key}) : super(key: key);
  final double fontSize = 21;
  @override
  Widget build(BuildContext context) {
    var animationForward = Provider.of<Code>(context);
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Card(
      margin: const EdgeInsets.all(0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 95, 60, 146),
                Color.fromARGB(255, 95, 85, 146)
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            )),
          ),
          Column(
            children: [
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity > 300) {
                    Auth.signOut();
                    Navigator.pushReplacementNamed(context, '/prijava2');
                  }
                },
                child: ClipPath(
                  clipper: MyCustomClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(left: 20),
                    margin: const EdgeInsets.only(bottom: 10),
                    height: 200,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: [Colors.grey[350], Colors.white],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Odabrani',
                          style: TextStyle(
                              color: Color.fromARGB(255, 95, 60, 146),
                              fontSize: fontSize + 16,
                              fontStyle: FontStyle.italic),
                        ),
                        ActivationCode(fontSize: fontSize),
                        SizedBox(
                          width: 150,
                          height: 25,
                          child: TextButton(
                            child: Text(
                              'Slaven Mišović',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 95, 60, 146),
                                  fontSize: fontSize - 5,
                                  fontStyle: FontStyle.italic),
                            ),
                            style: TextButton.styleFrom(
                                side: BorderSide.none,
                                backgroundColor: Colors.transparent,
                                padding: const EdgeInsets.all(0),
                                fixedSize: const Size(150, 0)),
                            onPressed: () {
                              animationForward.setAnimationForward(true);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(child: InitListAnimation(fontSize: fontSize))
            ],
          ),
          animationForward.getAnimationForward
              ? ChangeData(
                  slaven: 'Slaven',
                  screenHeight: screenHeight,
                  keyboard: keyboard,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

class ActivationCode extends StatefulWidget {
  const ActivationCode({
    Key key,
    @required this.fontSize,
  }) : super(key: key);

  final double fontSize;

  @override
  State<ActivationCode> createState() => _ActivationCodeState();
}

class _ActivationCodeState extends State<ActivationCode> {
  String activationCode;
  Future getActCode() async {
    return await Database.getActCode();
  }

  @override
  void initState() {
    getActCode().then((value) {
      setState(() {
        activationCode = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var actCode = Provider.of<Code>(context);
    return Row(
      children: [
        const Icon(
          Icons.qr_code_2,
          color: Colors.black,
        ),
        const SizedBox(
          width: 15,
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            side: BorderSide.none,
            backgroundColor: Colors.transparent,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => DialogChosen(
                      activationCode: activationCode,
                      fontSize: widget.fontSize,
                      changeCode: true,
                      forgetPassword: false,
                    ),
                barrierDismissible: true);
          },
          child: activationCode != null
              ? Text(
                  actCode.getActCode ?? activationCode,
                  style: TextStyle(
                      color: Color.fromARGB(255, 95, 60, 146),
                      fontSize: widget.fontSize),
                )
              : LimitedBox(
                  maxHeight: 25,
                  maxWidth: 100,
                  child: LinearProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 95, 60, 146)),
                ),
        ),
      ],
    );
  }
}

class InitListAnimation extends StatefulWidget {
  const InitListAnimation({
    Key key,
    @required this.fontSize,
  }) : super(key: key);

  final double fontSize;

  @override
  State<InitListAnimation> createState() => _InitListAnimationState();
}

class _InitListAnimationState extends State<InitListAnimation> {
  List clients;
  List podaciKlijenata;
  List ids;
  String imeIprezime;
  String id;
  Client client = Client();
  String uid = FirebaseAuth.instance.currentUser.uid;
  Future getClients() async {
    return await Database.getClients();
  }

  Future getSlaven(String id) async {
    return await Database.getClientData(id: id);
  }

  @override
  void initState() {
    super.initState();
    var slavenProvider = Provider.of<Slaven>(context, listen: false);
    getSlaven(uid).then((value) => slavenProvider.setSlavenData(value));
    getClients().then((value) {
      setState(() {
        clients = value;
        podaciKlijenata = clients[0];
        ids = clients[1];
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    clients;
    podaciKlijenata;
    ids;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxWidth: 500),
        child: clients == null
            ? CircularProgressIndicator(
                color: Color.fromARGB(255, 95, 60, 146),
                strokeWidth: 6,
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int i) {
                  id = ids[i];
                  imeIprezime =
                      '${podaciKlijenata[i]['name']} ${podaciKlijenata[i]['lastName']}';
                  return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 200 + i * 200),
                    tween: Tween<double>(begin: screenWidth + 50, end: 0),
                    curve: Curves.fastOutSlowIn,
                    builder: (BuildContext context, double _val, Widget child) {
                      return Transform.translate(
                        offset: Offset(_val, 0),
                        child: child,
                      );
                    },
                    child: Dismissible(
                      key: ObjectKey(podaciKlijenata[i]),
                      direction: DismissDirection.startToEnd,
                      resizeDuration: const Duration(milliseconds: 700),
                      movementDuration: const Duration(milliseconds: 400),
                      background: Container(
                        alignment: const Alignment(-0.7, 0.0),
                        color: Colors.transparent,
                        child: const Icon(
                          Icons.delete_forever,
                          size: 35,
                        ),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog(
                            context: context,
                            builder: (_) => DialogChosen(
                                  imeIprezime:
                                      '${podaciKlijenata[i]['name']} ${podaciKlijenata[i]['lastName']}',
                                  fontSize: widget.fontSize,
                                  changeCode: false,
                                  forgetPassword: false,
                                ),
                            barrierDismissible: true);
                      },
                      onDismissed: (dismissed) async {
                        await CloudFunctions.deleteImages(uid: ids[i]);
                        await Database.deleteClient(id: ids[i]);
                        await CloudFunctions.deleteUser(uid: ids[i]);

                        setState(() {
                          podaciKlijenata.removeAt(i);
                          ids.removeAt(i);
                        });
                      },
                      child: ClientsList(
                          podaciKlijenta: podaciKlijenata[i],
                          imeIprezime: imeIprezime,
                          id: id,
                          fontSize: widget.fontSize),
                    ),
                  );
                },
                itemCount: ids.length,
              ),
      ),
    );
  }
}

class ClientsList extends StatelessWidget {
  ClientsList(
      {Key key,
      @required this.imeIprezime,
      @required this.fontSize,
      @required this.id,
      @required this.podaciKlijenta})
      : super(key: key);
  final String id;
  final String imeIprezime;
  final double fontSize;
  final Map podaciKlijenta;
  Client client = Client();
  @override
  Widget build(BuildContext context) {
    var clientsDataProvider = Provider.of<Client>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
      clipper: ClientClipper(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(40, 0, 15, 0),
        margin: const EdgeInsets.fromLTRB(15, 10, 0, 10),
        height: 70,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              spreadRadius: 2.5,
            )
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(screenWidth >= 500 ? 20 : 0),
              bottomRight: Radius.circular(screenWidth >= 500 ? 20 : 0),
              bottomLeft: const Radius.circular(10)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LimitedBox(
              maxWidth: screenWidth - 120,
              child: Text(
                imeIprezime,
                style: TextStyle(fontSize: fontSize + 5, color: Colors.white),
              ),
            ),
            IconButton(
                onPressed: () {
                  client.name = podaciKlijenta['name'];
                  client.lastName = podaciKlijenta['lastName'];
                  client.email = podaciKlijenta['email'];
                  client.phone = podaciKlijenta['phone'];
                  client.admin = podaciKlijenta['admin'];
                  client.age = podaciKlijenta['age'];
                  client.height = podaciKlijenta['height'];
                  client.id = id;
                  clientsDataProvider.setClientData(client);

                  Navigator.pushNamed(context, '/profil', arguments: true);
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 95, 60, 146),
                ))
          ],
        ),
      ),
    );
  }
}
