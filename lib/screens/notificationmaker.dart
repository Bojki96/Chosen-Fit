import 'package:chosen/functions.dart';
import 'package:chosen/notifications.dart';
import 'package:chosen/providers/client.dart';
import 'package:chosen/services/sharedpreferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationMaker extends StatefulWidget {
  const NotificationMaker({Key key}) : super(key: key);

  @override
  _NotificationMakerState createState() => _NotificationMakerState();
}

double fontSize = 21;

class _NotificationMakerState extends State<NotificationMaker> {
  TextEditingController waterController = TextEditingController();
  TextEditingController mealController = TextEditingController();
  var waterNotificationKey = GlobalKey<FormState>();
  var mealNotificationKey = GlobalKey<FormState>();
  Notifications _notifications = Notifications();
  @override
  Widget build(BuildContext context) {
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text(
          'Postavi podsjetnike',
          style: TextStyle(fontSize: fontSize + 2),
        ),
        backgroundColor: Color.fromARGB(255, 95, 60, 146),
      ),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Podsjetnik(
                waterController: waterController,
                whichNotification: 'Podsjetnik za unos vode',
                notificationKey: waterNotificationKey,
              ),
              Podsjetnik(
                  waterController: mealController,
                  whichNotification: 'Podsjetnik za unos obroka',
                  notificationKey: mealNotificationKey)
            ],
          ),
        ),
      ),
      floatingActionButton: keyboard > 0
          ? SizedBox()
          : FloatingActionButton(
              onPressed: () async {
                LocalStorage.removeNotifications();
                _notifications.cancelAllNotifications();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    behavior: SnackBarBehavior.fixed,
                    content: Text('Otkazane sve notifikacije',
                        style: TextStyle(color: Colors.white))));
              },
              backgroundColor: Color.fromARGB(255, 95, 60, 146),
              child: Icon(Icons.notifications_off_outlined),
            ),
    );
  }
}

class Podsjetnik extends StatefulWidget {
  const Podsjetnik({
    Key key,
    @required this.waterController,
    @required this.whichNotification,
    @required this.notificationKey,
  }) : super(key: key);
  final String whichNotification;
  final TextEditingController waterController;
  final notificationKey;
  @override
  State<Podsjetnik> createState() => _PodsjetnikState();
}

class _PodsjetnikState extends State<Podsjetnik> {
  bool pressed = false;
  bool changedNumber = false;
  int numberOfNotifications;
  bool saved = false;

  void changedNumberCallBack(bool changed) {
    setState(() {
      changedNumber = changed;
    });
  }

  void numberZeroCallBack(int number) {
    setState(() {
      numberOfNotifications = number;
      saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: EdgeInsets.all(8),
              width: 280,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 95, 60, 146),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Text(
                widget.whichNotification,
                style: TextStyle(fontSize: fontSize + 1, color: Colors.white),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Broj dnevnih notifikacija:',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Color.fromARGB(255, 95, 60, 146),
                    ),
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                LimitedBox(
                  maxWidth: 60,
                  child: Form(
                    key: widget.notificationKey,
                    child: TextFormField(
                      readOnly: saved,
                      validator: (value) {
                        try {
                          numberOfNotifications = int.parse(value);
                        } on FormatException {
                          return '';
                        }
                        ;
                      },
                      controller: widget.waterController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: fontSize),
                      decoration: InputDecoration(
                        isDense: false,
                        contentPadding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple[700]),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple[800]),
                            borderRadius: BorderRadius.circular(10)),
                        errorStyle: TextStyle(height: 0),
                      ),
                      onSaved: (value) {
                        widget.waterController.value =
                            widget.waterController.value.copyWith(text: value);
                      },
                      onChanged: (value) {
                        changedNumber = true;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 95, 60, 146),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: IconButton(
                      onPressed: () {
                        if (widget.notificationKey.currentState.validate()) {
                          widget.notificationKey.currentState.save();
                          setState(() {
                            pressed = true;
                          });
                          FocusScope.of(context).unfocus();
                        }
                      },
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                      )),
                )
              ],
            ),
          ),
          pressed && numberOfNotifications > 0
              ? WaterNotifications(
                  numberOfNotifications: numberOfNotifications,
                  whichNotifications: widget.whichNotification,
                  changed: changedNumberCallBack,
                  changedNumber: changedNumber,
                  numberZeroCallBack: numberZeroCallBack,
                )
              : SizedBox()
        ],
      ),
    );
  }
}

class WaterNotifications extends StatefulWidget {
  WaterNotifications(
      {Key key,
      @required this.numberOfNotifications,
      @required this.whichNotifications,
      @required this.changedNumber,
      @required this.changed,
      @required this.numberZeroCallBack})
      : super(key: key);
  final int numberOfNotifications;
  final String whichNotifications;
  bool changedNumber;
  final Function changed;
  final Function numberZeroCallBack;
  @override
  _WaterNotificationsState createState() => _WaterNotificationsState();
}

class _WaterNotificationsState extends State<WaterNotifications>
    with TickerProviderStateMixin {
  String minute;
  String hour;
  Map controllerTime = {};
  AnimationController animationController;
  Animation<double> opacityTitle;
  Animation<double> opacityList;
  Animation<double> opacitySave;
  bool timeChosen = false;
  Notifications _notifications = Notifications();
  var _waterNotificationKey2 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controllerTime = Controllers.controllerList(widget.numberOfNotifications);
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));

    opacityTitle = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.35, curve: Curves.easeIn)));

    opacityList = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.35, 1.0, curve: Curves.easeIn)));

    opacitySave = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.75, 1.0, curve: Curves.easeIn)));

    animationController.forward();
  }

  @override
  void didUpdateWidget(covariant WaterNotifications oldWidget) {
    if (widget.changedNumber) {
      controllerTime = Controllers.controllerList(widget.numberOfNotifications);
      super.didUpdateWidget(oldWidget);
    }
  }

  @override
  void dispose() {
    super.dispose();
    animationController;
  }

  @override
  Widget build(BuildContext context) {
    var client = Provider.of<Client>(context);
    return Form(
      key: _waterNotificationKey2,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Opacity(
                  opacity: opacityTitle.value,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 95, 60, 146),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Text(
                      'Unesi vrijeme:',
                      style: TextStyle(color: Colors.white, fontSize: fontSize),
                    ),
                  ),
                ),
                Opacity(
                  opacity: opacityList.value,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color.fromARGB(255, 95, 60, 146)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${i + 1}. notifikacije',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 95, 60, 146),
                                    fontSize: fontSize),
                              ),
                              LimitedBox(
                                maxWidth: 85,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return '';
                                    }
                                  },
                                  readOnly: true,
                                  controller: controllerTime['kontroler$i'],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: fontSize),
                                  decoration: InputDecoration(
                                    isDense: false,
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purple[700]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.purple[800]),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    errorStyle: TextStyle(height: 0),
                                  ),
                                  onTap: () async {
                                    final newTime = await showTimePicker(
                                      initialEntryMode:
                                          TimePickerEntryMode.input,
                                      context: context,
                                      initialTime:
                                          TimeOfDay(hour: 12, minute: 0),
                                      confirmText: 'OK',
                                      cancelText: 'Otkaži',
                                      helpText: '${i + 1}. notifikacija',
                                    );
                                    if (newTime == null)
                                      return;
                                    else {
                                      setState(() {
                                        widget.changed(false);
                                        newTime.hour < 10
                                            ? hour = '0${newTime.hour}'
                                            : hour = '${newTime.hour}';
                                        newTime.minute < 10
                                            ? minute = '0${newTime.minute}'
                                            : minute = '${newTime.minute}';
                                        controllerTime['kontroler$i'].value =
                                            controllerTime['kontroler$i']
                                                .value
                                                .copyWith(
                                                    text: '$hour:$minute');
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: widget.numberOfNotifications,
                    ),
                  ),
                ),
                Center(
                  child: Opacity(
                    opacity: opacitySave.value,
                    child: TextButton(
                        onPressed: () async {
                          if (_waterNotificationKey2.currentState.validate()) {
                            _waterNotificationKey2.currentState.save();
                            List<String> sati = [];
                            DateTime danas = DateTime.now();

                            for (int i = 0;
                                i < widget.numberOfNotifications;
                                i++) {
                              sati.add(controllerTime['kontroler$i'].text);
                            }
                            if (widget.whichNotifications ==
                                'Podsjetnik za unos vode') {
                              await LocalStorage.setWaterDates(dates: sati);
                              List<String> datesWater =
                                  await SetWaterNotifications
                                      .setWaterNotifications(
                                          sati: sati, datum: danas);
                              for (int i = 0; i < datesWater.length; i++) {
                                await _notifications.showDailyAtTime(
                                  datum: datesWater[i],
                                  clientName: client.getClientData['name'],
                                  prehrana: false,
                                  i: i,
                                );
                              }
                            } else {
                              await LocalStorage.setMealDates(dates: sati);
                              List<String> datesMeals =
                                  await SetWaterNotifications
                                      .setWaterNotifications(
                                          sati: sati, datum: danas);
                              for (int i = 0; i < datesMeals.length; i++) {
                                await _notifications.showDailyAtTime(
                                  datum: datesMeals[i],
                                  clientName: client.getClientData['name'],
                                  prehrana: true,
                                  i: i,
                                );
                              }
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    behavior: SnackBarBehavior.fixed,
                                    content: Text('Podsjetnici spremljeni!',
                                        style:
                                            TextStyle(color: Colors.white))));
                            await animationController.reverse();
                            widget.numberZeroCallBack(0);
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 95, 60, 146),
                            fixedSize: const Size(128, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        child: Text(
                          'Spremi',
                          style: TextStyle(
                              color: Colors.white, fontSize: fontSize),
                        )),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Divider(
                  thickness: 2.0,
                  color: Color.fromARGB(255, 95, 60, 146),
                )
              ],
            );
          }),
    );
  }
}
