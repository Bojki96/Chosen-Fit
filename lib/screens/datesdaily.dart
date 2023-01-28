import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chosen/providers/chosencode.dart';
import 'package:chosen/services/database.dart';
import 'package:intl/intl.dart';
import 'package:chosen/clip.dart';
import 'package:chosen/providers/client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyUpdateDates extends StatelessWidget {
  DailyUpdateDates({Key key}) : super(key: key);
  final animatedListKey = GlobalKey<AnimatedListState>();
  final double fontSize = 21;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    var clientDataProvider = Provider.of<Client>(context);
    return SafeArea(
      child: Card(
          margin: const EdgeInsets.all(0),
          child: Stack(children: [
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 260,
                  padding: const EdgeInsets.fromLTRB(8, 8, 32, 8),
                  alignment: Alignment.centerLeft,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 95, 60, 146),
                            Colors.transparent
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: [0.8, 0.2])),
                  child: AutoSizeText(
                    '${clientDataProvider.getClientData['name']} ${clientDataProvider.getClientData['lastName']}',
                    style: TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic),
                    presetFontSizes: [
                      fontSize + 17,
                      fontSize + 14,
                      fontSize + 10,
                      fontSize + 8,
                      fontSize + 4
                    ],
                    maxLines: 1,
                  ),
                ),
                Container(
                  width: 260,
                  padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color.fromARGB(255, 89, 48, 150)
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                          stops: const [0.095, 0])),
                  child: Text(
                    'Dnevni unosi',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                ListOfDates(
                  fontSize: fontSize,
                  screenWidth: screenWidth,
                )
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: SafeArea(
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            )
          ])),
    );
  }
}

class ListOfDates extends StatefulWidget {
  const ListOfDates({Key key, this.fontSize, this.screenWidth})
      : super(key: key);
  final double screenWidth;
  final double fontSize;

  @override
  State<ListOfDates> createState() => _ListOfDatesState();
}

class _ListOfDatesState extends State<ListOfDates> {
  FixedExtentScrollController listController;
  int selectedWeek = 0;
  bool colorChange = false;
  int itemToAnimate = 0;
  int ri = 0;

  pocniAnimaciju(int index) {
    listController.animateToItem(index,
        duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn);
  }

  bool stateChanged = false;
  @override
  void initState() {
    super.initState();
    listController = FixedExtentScrollController();
    var selectedWeekProvider = Provider.of<Code>(context, listen: false);
    Timer(const Duration(milliseconds: 500), () {
      pocniAnimaciju(selectedWeekProvider.getWeek);
    });
  }

  @override
  void dispose() {
    super.dispose();

    listController.dispose();
  }

  DateFormat formatDate = DateFormat("yyyy-MM-dd");
  DateFormat datumUString = DateFormat("d.M.yyyy.");

  @override
  Widget build(BuildContext context) {
    List clientsDailyList = ModalRoute.of(context).settings.arguments;
    var selectedWeekProvider = Provider.of<Code>(context, listen: false);
    var clientDataProvider = Provider.of<Client>(context);
    return clientsDailyList.isEmpty
        ? Center(
            child: Text(
            'Nije uploadan niti jedan dnevni unos',
            style: TextStyle(
                color: Colors.white,
                fontSize: widget.fontSize,
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ))
        : Expanded(
            child: GestureDetector(
              onTap: () async {
                String date = clientsDailyList[selectedWeekProvider.getWeek];
                Map dailyUpdate = await Database.getMeals(
                    id: clientDataProvider.getClientData['id'], date: date);
                String danasPrikaz =
                    datumUString.format(formatDate.parse(date));
                Navigator.pushNamed(context, '/dailyupdate', arguments: {
                  'dailyUpdate': dailyUpdate,
                  'datumPrikaz': danasPrikaz,
                  'admin': 'admin'
                });
              },
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: ListWheelScrollView.useDelegate(
                    controller: listController,
                    itemExtent: 95,
                    diameterRatio: 3,
                    overAndUnderCenterOpacity: 0.6,
                    squeeze: 0.9,
                    offAxisFraction: -0.75,
                    onSelectedItemChanged: (index) {
                      selectedWeek = index;
                      selectedWeekProvider.setWeek(selectedWeek);
                    },
                    physics: const FixedExtentScrollPhysics(),
                    childDelegate: ListWheelChildBuilderDelegate(
                        builder: (BuildContext context, int i) {
                          String date = clientsDailyList[i];
                          date = datumUString.format(formatDate.parse(date));
                          return DailyDates(
                            date: date,
                            screenWidth: widget.screenWidth,
                            fontSize: widget.fontSize,
                          );
                        },
                        childCount: clientsDailyList.length),
                  ),
                ),
              ),
            ),
          );
  }
}

class DailyDates extends StatelessWidget {
  DailyDates(
      {Key key,
      @required this.screenWidth,
      @required this.fontSize,
      @required this.date,
      this.textColor,
      this.borderColor})
      : super(key: key);
  Color borderColor;
  Color textColor;
  final double screenWidth;
  final double fontSize;
  String date;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DailyDatesClipper(),
      child: Container(
        height: 70,
        width: screenWidth,
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        decoration: const BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black45)],
            border: Border.symmetric(
                horizontal: BorderSide(
              color: Colors.white,
              width: 2,
            ))),
        child: Text(
          date,
          style: TextStyle(color: Colors.white, fontSize: fontSize + 5),
        ),
      ),
    );
  }
}
