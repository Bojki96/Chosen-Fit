import 'package:chosen/changedata.dart';
import 'package:chosen/clip.dart';
import 'package:chosen/loadingdata.dart';
import 'package:chosen/notifications.dart';
import 'package:chosen/providers/chosencode.dart';
import 'package:chosen/providers/client.dart';
import 'package:chosen/providers/meals.dart';
import 'package:chosen/services/auth.dart';
import 'package:chosen/services/database.dart';
import 'package:chosen/services/sharedpreferences.dart';
import 'package:chosen/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../functions.dart';
import '../loginanimation.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Profil extends StatefulWidget {
  const Profil({Key key}) : super(key: key);

  @override
  State<Profil> createState() => _ProfilState();
}

double fontSize = 21;

class _ProfilState extends State<Profil> with TickerProviderStateMixin {
  AnimationController _editController;
  Client client = Client(name: 'ModelName', lastName: 'ModelLastName');
  Notifications _notifications = Notifications();
  String userID = FirebaseAuth.instance.currentUser.uid;
  Map slaven = {};
  Map slavenData = {};
  bool removeFAB = false;
  Future getSlavenContact() async {
    return await Database.getAdmin();
  }

  pocniAnimaciju() {
    _editController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
  }

  Future getClientData({String id}) async {
    return await Database.getClientData(id: id);
  }

  Future getClientWeight({String id}) async {
    return await Database.getClientWeight(id: id);
  }

  showNotifications({String name}) async {
    await _notifications.cancelAllNotifications();
    List hoursWater = await LocalStorage.getWaterDates();
    List hoursMeals = await LocalStorage.getMealDates();
    DateTime datum = DateTime.now();

    if (hoursWater != null) {
      List<String> datesWater =
          await SetWaterNotifications.setWaterNotifications(
              sati: hoursWater, datum: datum);
      for (int i = 0; i < datesWater.length; i++) {
        await _notifications.showDailyAtTime(
          datum: datesWater[i],
          clientName: name,
          prehrana: false,
          i: i,
        );
      }
    }
    if (hoursMeals != null) {
      List<String> datesMeals =
          await SetWaterNotifications.setWaterNotifications(
              sati: hoursMeals, datum: datum);
      for (int i = 0; i < datesMeals.length; i++) {
        await _notifications.showDailyAtTime(
          datum: datesMeals[i],
          clientName: name,
          prehrana: true,
          i: i,
        );
      }
    }
  }

  Map clientDataRoute = {};
  @override
  void initState() {
    super.initState();
    var clientProvider = Provider.of<Client>(context, listen: false);
    var slavenProvider = Provider.of<Slaven>(context, listen: false);
    var weightListener = Provider.of<DailyUpdateInput>(context, listen: false);
    slaven = slavenProvider.getSlavenData;
    getSlavenContact().then((value) {
      setState(() {
        slavenData = value;
      });
    });
    if (slaven == null) {
      getClientData(id: userID).then((value) {
        setState(() {
          clientProvider.setClientData(value);
        });
        showNotifications(name: clientProvider.getClientData['name']);
        getClientWeight(id: clientProvider.getClientData['id']).then((value) {
          setState(() {
            weightListener.setWeight(value['weight']);
          });
        });
      });
    } else {
      getClientWeight(id: clientProvider.getClientData['id']).then((value) {
        setState(() {
          weightListener.setWeight(value['weight']);
        });
      });
    }
    pocniAnimaciju();
  }

  @override
  void dispose() {
    super.dispose();
    _editController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var clientProvider = Provider.of<Client>(context);
    var animationForward = Provider.of<Code>(context);
    var weightListener = Provider.of<DailyUpdateInput>(context);
    var admin = ModalRoute.of(context).settings.arguments;
    double screenHeight = MediaQuery.of(context).size.height;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      body: clientProvider.getClientData == null
          ? LoadingData(text: 'Učitavanje podataka')
          : Stack(
              children: [
                Container(
                  color: Color.fromARGB(255, 95, 60, 146),
                ),
                SafeArea(
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ClipPath(
                          clipper: MyCustomClipper(),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                            height: 200,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 95, 60, 146)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  '${clientProvider.getClientData['name']} ${clientProvider.getClientData['lastName']}',
                                  style: const TextStyle(color: Colors.white),
                                  presetFontSizes: [
                                    fontSize + 18,
                                    fontSize + 14,
                                    fontSize + 12,
                                    fontSize + 10
                                  ],
                                  maxLines: screenHeight < 560 ? 1 : 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 30),
                                  child: AutoSizeText(
                                    'Godine: ${clientProvider.getClientData['age']}/Visina: ${clientProvider.getClientData['height']} cm/Kilaža: ${weightListener.getWeight} kg',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    presetFontSizes: [
                                      fontSize - 2,
                                      fontSize - 4,
                                      fontSize - 6,
                                      fontSize - 8,
                                    ],
                                    maxLines: 1,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/chart');
                                    },
                                    icon: Icon(
                                      Icons.show_chart_outlined,
                                      color: Colors.white,
                                      size: 35,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          height: screenHeight - 350,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              UpdateButtons(nazivGumba: 'Daily\nupdate'),
                              SizedBox(
                                height: 50,
                              ),
                              UpdateButtons(nazivGumba: 'Weekly\nupdate'),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  left: 8,
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        admin != null
                            ? const SizedBox()
                            : IconButton(
                                onPressed: () async {
                                  for (int i = 0; i < 9; i++) {
                                    controller['kontroler$i'].value =
                                        controller['kontroler$i']
                                            .value
                                            .copyWith(text: '');
                                  }
                                  changed = false;
                                  await Auth.signOut();
                                  Navigator.pushReplacementNamed(
                                      context, '/prijava2');
                                },
                                icon: const Icon(Icons.logout_rounded,
                                    color: Colors.white)),
                        admin != null
                            ? IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Colors.white,
                                ))
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
                admin != null
                    ? const SizedBox()
                    : animationForward.getAnimationForward
                        ? ChangeData(
                            screenHeight: screenHeight,
                            keyboard: keyboard,
                          )
                        : const SizedBox()
              ],
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: animationForward.getAnimationForward
            ? SizedBox()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 95, 60, 146),
                    child: Icon(
                      Icons.call,
                      size: 40,
                    ),
                    onPressed: () async {
                      if (admin != null) {
                        await canLaunch(
                                "tel://${clientProvider.getClientData['phone']}")
                            ? await launch(
                                "tel://${clientProvider.getClientData['phone']}")
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    content: Text(
                                        'Broj se trenutno ne može nazvati',
                                        style:
                                            TextStyle(color: Colors.white))));
                      } else {
                        await canLaunch("tel://${slavenData['phone']}")
                            ? await launch("tel://${slavenData['phone']}")
                            : ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    content: Text(
                                        'Broj se trenutno ne može nazvati',
                                        style:
                                            TextStyle(color: Colors.white))));
                      }
                    },
                    heroTag: null,
                  ),
                  admin != null
                      ? SizedBox(
                          width: 40,
                        )
                      : FloatingActionButton(
                          backgroundColor: Color.fromARGB(255, 95, 60, 146),
                          child:
                              Icon(Icons.notification_add_outlined, size: 40),
                          onPressed: () {
                            Navigator.pushNamed(context, '/notificationmaker');
                          },
                          heroTag: null,
                        ),
                  admin != null
                      ? SizedBox(
                          width: 40,
                        )
                      : FloatingActionButton(
                          backgroundColor: Color.fromARGB(255, 95, 60, 146),
                          child: Icon(Icons.settings, size: 40),
                          onPressed: () {
                            removeFAB = true;
                            changed = false;
                            animationForward.setAnimationForward(true);
                            _editController.forward();
                          },
                          heroTag: null,
                        )
                ],
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class UpdateButtons extends StatelessWidget {
  String nazivGumba;
  UpdateButtons({Key key, @required this.nazivGumba}) : super(key: key);

  Map dailyUpdate = {};
  DateTime danas = DateTime.now();
  DateFormat formatDate = DateFormat("yyyy-MM-dd");
  DateFormat datumUString = DateFormat("dd/MM/yyyy");
  @override
  Widget build(BuildContext context) {
    var client = Provider.of<Client>(context);
    var lastWeek = Provider.of<Code>(context, listen: false);
    var dailyInputProvider = Provider.of<DailyUpdateInput>(context);
    return TextButton(
        onPressed: () async {
          String currentID = FirebaseAuth.instance.currentUser.uid;
          String clientID = client.getClientData['id'];
          if (nazivGumba == 'Daily\nupdate') {
            if (currentID != clientID) {
              List clientDailyList =
                  await Database.getDailyUpdates(id: clientID);
              lastWeek.setWeek(clientDailyList.length - 1);
              Navigator.pushNamed(context, '/datesdaily',
                  arguments: clientDailyList);
            } else {
              String danasUBazu = formatDate.format(danas);
              String danasPrikaz = datumUString.format(danas);
              dailyUpdate = await Database.getMeals(
                  id: currentID, date: formatDate.format(danas));

              if (dailyUpdate['Meals'] != null) {
                int mealNumber = dailyUpdate['Meals'].length;
                dailyInputProvider.resetMealNumber();
                if (mealNumber > 4) {
                  for (int i = 4; i < dailyUpdate['Meals'].length; i++) {
                    dailyInputProvider.addMeal(i);
                  }
                }
              }
              Navigator.pushNamed(context, '/dailyupdate', arguments: {
                'dailyUpdate': dailyUpdate,
                'datumUBazu': danasUBazu,
                'datumPrikaz': danasPrikaz
              });
            }
          } else {
            if (currentID != clientID) {
              List clientWeeklyList =
                  await Database.getWeeklyDates(id: clientID);
              lastWeek.setWeek(clientWeeklyList.length - 1);
              Navigator.pushNamed(context, '/weeklydates',
                  arguments: clientWeeklyList);
            } else {
              String tjedan = DateCalculation.calculateWeekDates(
                  dateNow: DateTime.now(), upload: false);
              String datumNedjelje = DateCalculation.calculateWeekDates(
                  dateNow: DateTime.now(), upload: true);
              DateFormat datumUBazu = DateFormat("d.M.yyyy.");
              String nedjeljaUBazu =
                  formatDate.format(datumUBazu.parse(datumNedjelje));
              Map weightFromDatabase = await Database.getWeight(
                  id: client.getClientData['id'], date: nedjeljaUBazu);
              String weight;
              if (weightFromDatabase != null) {
                weight = weightFromDatabase['weight'];
              }
              Navigator.pushNamed(context, '/weeklyupdate', arguments: {
                'datumNedjelje': datumNedjelje,
                'tjedan': tjedan,
                'weight': weight,
              });
            }
          }
        },
        child: Text(
          nazivGumba == 'Daily\nupdate' ? 'Dnevni unos' : 'Tjedni unos',
          style: TextStyle(color: Colors.white, fontSize: fontSize + 5),
        ));
  }
}
