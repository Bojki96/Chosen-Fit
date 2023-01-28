import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chosen/providers/chosencode.dart';
import 'package:chosen/providers/client.dart';
import 'package:chosen/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WeeklyUpdateDates extends StatefulWidget {
  WeeklyUpdateDates({Key key}) : super(key: key);

  @override
  State<WeeklyUpdateDates> createState() => _WeeklyUpdateDatesState();
}

class _WeeklyUpdateDatesState extends State<WeeklyUpdateDates> {
  double fontSize = 21;
  FixedExtentScrollController listController;
  int selectedWeek;
  DateFormat formatDate = DateFormat("yyyy-MM-dd");
  DateFormat datumUString = DateFormat("d.M.yyyy.");
  pocniAnimaciju(int index) {
    listController.animateToItem(index,
        duration: Duration(seconds: 3), curve: Curves.fastOutSlowIn);
  }

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

  @override
  Widget build(BuildContext context) {
    var client = Provider.of<Client>(context);
    var selectedWeekProvider = Provider.of<Code>(context, listen: false);
    List clientsWeeklyList = ModalRoute.of(context).settings.arguments;
    return Card(
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
          SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 100,
                width: 260,
                padding: const EdgeInsets.fromLTRB(8, 8, 32, 8),
                alignment: Alignment.centerLeft,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.transparent],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: [0.8, 0.2])),
                child: AutoSizeText(
                  '${client.getClientData['name']} ${client.getClientData['lastName']}',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 95, 60, 146),
                      fontStyle: FontStyle.italic),
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
                          Color.fromARGB(255, 95, 60, 146)
                        ],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        stops: const [0.095, 0])),
                child: Text(
                  'Tjedni unosi',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontStyle: FontStyle.italic),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              clientsWeeklyList.isEmpty
                  ? Center(
                      child: Text(
                      'Nije uploadan niti jedan tjedni unos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: fontSize,
                          fontStyle: FontStyle.italic),
                    ))
                  : Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          String date =
                              clientsWeeklyList[selectedWeekProvider.getWeek];
                          Map weightFromDatabase = await Database.getWeight(
                              id: client.getClientData['id'], date: date);
                          DateTime nedjelja = formatDate.parse(date);
                          DateTime ponedjeljak =
                              nedjelja.add(const Duration(days: -6));
                          String tjedan =
                              '${datumUString.format(ponedjeljak)} - ${datumUString.format(nedjelja)}';
                          String datumNedjelje = datumUString.format(nedjelja);
                          Navigator.pushNamed(context, '/weeklyupdate',
                              arguments: {
                                'datumNedjelje': datumNedjelje,
                                'tjedan': tjedan,
                                'weight': weightFromDatabase['weight'],
                                'admin': 'admin'
                              });
                        },
                        child: Center(
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: 500,
                            ),
                            child: ListWheelScrollView.useDelegate(
                              controller: listController,
                              itemExtent: 95,
                              diameterRatio: 3,
                              overAndUnderCenterOpacity: 0.5,
                              squeeze: 0.9,
                              onSelectedItemChanged: (index) {
                                selectedWeek = index;
                                selectedWeekProvider.setWeek(selectedWeek);
                              },
                              physics: const FixedExtentScrollPhysics(),
                              childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (BuildContext context, int i) {
                                    String date = clientsWeeklyList[i];
                                    DateTime nedjelja = formatDate.parse(date);
                                    DateTime ponedjeljak =
                                        nedjelja.add(const Duration(days: -6));
                                    String tjedan =
                                        '${datumUString.format(ponedjeljak)} - ${datumUString.format(nedjelja)}';

                                    return Weeks(
                                      fontSize: fontSize,
                                      weekDate: tjedan,
                                      i: i,
                                    );
                                  },
                                  childCount: clientsWeeklyList.length),
                            ),
                          ),
                        ),
                      ),
                    )
            ]),
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
        ]));
  }
}

class Weeks extends StatelessWidget {
  const Weeks(
      {Key key,
      @required this.fontSize,
      @required this.weekDate,
      @required this.i})
      : super(key: key);

  final double fontSize;
  final String weekDate;
  final int i;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 8),
          child: Text(
            'Tjedan ${i + 1}.',
            style: TextStyle(color: Colors.white, fontSize: fontSize + 3),
          ),
        ),
        subtitle: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Text(
            weekDate,
            style: TextStyle(
                color: Color.fromARGB(255, 95, 60, 146),
                fontSize: fontSize - 4,
                fontStyle: FontStyle.italic),
          ),
        ),
        trailing: const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 5, 0),
          child: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black26,
          ),
        ),
      ),
    );
  }
}
