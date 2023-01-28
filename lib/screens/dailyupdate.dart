import 'package:chosen/buttons.dart';
import 'package:chosen/functions.dart';
import 'package:chosen/loadingdata.dart';
import 'package:chosen/providers/meals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double fontSize = 21;

class DailyUpdate extends StatefulWidget {
  DailyUpdate({Key key}) : super(key: key);

  @override
  State<DailyUpdate> createState() => _DailyUpdateState();
}

var dailyUpdateKey = GlobalKey<FormState>();

class _DailyUpdateState extends State<DailyUpdate> {
  DailyUpdateInput dailyInput = DailyUpdateInput();
  TextEditingController waterController = TextEditingController();
  Map dailyUpdate = {};
  String admin;
  bool loadingWidget = false;
  loadingWidgetFunction(bool loading) {
    setState(() {
      loadingWidget = loading;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    dailyUpdateKey;
  }

  @override
  Widget build(BuildContext context) {
    Map gatheredData = ModalRoute.of(context).settings.arguments;
    dailyUpdate = gatheredData['dailyUpdate'];
    admin = gatheredData['admin'];
    if (dailyUpdate['WaterIntake'] != null) {
      waterController.value =
          waterController.value.copyWith(text: dailyUpdate['WaterIntake']);
      dailyInput.waterIntake = waterController.text;
    }

    return SafeArea(
      child: Card(
          margin: const EdgeInsets.all(0),
          borderOnForeground: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(8),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 95, 60, 146),
                            ),
                            child: Text(
                              'Dnevni unos',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: fontSize + 14,
                              ),
                            ),
                          ),
                          Positioned(
                              top: 6,
                              left: 10,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                  ))),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 89, 48, 150),
                        ),
                        child: Text(
                          gatheredData['datumPrikaz'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: fontSize - 3,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          children: [
                            Text(
                              'Unos vode:',
                              style: TextStyle(
                                  fontSize: fontSize + 3,
                                  color: Color.fromARGB(255, 95, 60, 146)),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            LimitedBox(
                              maxWidth: 60,
                              child: TextField(
                                readOnly: admin != null ? true : false,
                                controller: waterController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: fontSize + 3),
                                decoration: InputDecoration(
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 95, 60, 146)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 95, 60, 146)),
                                  ),
                                ),
                                onChanged: (value) {
                                  dailyInput.waterIntake = value;
                                  waterController.value = waterController.value
                                      .copyWith(text: value);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'L',
                              style: TextStyle(
                                  fontSize: fontSize + 3,
                                  color: Color.fromARGB(255, 95, 60, 146)),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                      ),
                      Meals(
                        dailyInput: dailyInput,
                        dailyUpdate: dailyUpdate,
                        admin: admin,
                      ),
                    ]),
              ),
              admin != null
                  ? const SizedBox()
                  : Buttons(
                      gumb: 'Save',
                      date: gatheredData['datumUBazu'],
                      loadingWidgetCallBack: loadingWidgetFunction,
                    ),
              admin == null
                  ? Buttons(
                      gumb: 'Add',
                    )
                  : SizedBox(),
              loadingWidget ? LoadingData(text: 'Spremanje') : const SizedBox(),
            ],
          )),
    );
  }
}

class Meals extends StatefulWidget {
  Meals(
      {Key key,
      @required this.dailyInput,
      @required this.dailyUpdate,
      @required this.admin})
      : super(key: key);

  DailyUpdateInput dailyInput = DailyUpdateInput();
  Map dailyUpdate;
  String admin;
  @override
  State<Meals> createState() => _MealsState();
}

class _MealsState extends State<Meals> {
  List mealNumber = [];
  Map mealController = Controllers.listOfControllers();
  bool lastMeal = false;
  bool textFieldChanged = false;
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    var dailyInputProvider = Provider.of<DailyUpdateInput>(context);

    mealNumber = dailyInputProvider.getMealNumber;

    return Form(
      key: dailyUpdateKey,
      child: Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            itemBuilder: (BuildContext context, int i) {
              if (widget.dailyUpdate['Meals'] != null) {
                if (!textFieldChanged) {
                  if (dailyInputProvider.getMealAddedAfterWhile) {
                    widget.dailyUpdate['Meals'].add('');
                  }
                  mealController['kontroler$i'].value =
                      mealController['kontroler$i']
                          .value
                          .copyWith(text: widget.dailyUpdate['Meals'][i]);
                }
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 60,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 95, 60, 146)),
                      child: Text(
                        'Obrok ${i + 1}',
                        style: TextStyle(
                            color: Colors.white, fontSize: fontSize + 2),
                      ),
                    ),
                    Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 600),
                        height: 600,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          readOnly: widget.admin != null ? true : false,
                          controller: mealController['kontroler$i'],
                          textInputAction: TextInputAction.newline,
                          maxLines: 20,
                          onTap: () {
                            tapped = true;
                            if (widget.admin == null) {
                              if (i == mealNumber.length - 1) {
                                setState(() {
                                  lastMeal = true;
                                });
                              } else {
                                setState(() {
                                  lastMeal = false;
                                });
                              }
                            }
                          },
                          style: TextStyle(fontSize: fontSize),
                          decoration: InputDecoration(
                            isDense: false,
                            contentPadding:
                                const EdgeInsets.fromLTRB(8, 15, 8, 15),
                            label: widget.dailyUpdate['Meals'] != null
                                ? tapped || widget.dailyUpdate['Meals'][i] != ''
                                    ? Text('Unesi ${mealNumber[i]} obrok')
                                    : Center(
                                        child: Text(
                                            'Unesi ${mealNumber[i]} obrok'),
                                      )
                                : tapped
                                    ? Text('Unesi ${mealNumber[i]} obrok')
                                    : Center(
                                        child: Text(
                                            'Unesi ${mealNumber[i]} obrok')),
                            labelStyle: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 95, 60, 146)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color.fromARGB(255, 95, 60, 146),
                                    width: 3.0),
                                borderRadius: BorderRadius.circular(20)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 95, 60, 146),
                                    width: 3.0),
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 95, 60, 146),
                                    width: 3.0),
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onChanged: (value) {
                            textFieldChanged = true;
                          },
                          onSaved: (value) {
                            if (value == null) {
                              widget.dailyInput.meals.add('');
                            }
                            widget.dailyInput.meals.add(value);
                            dailyInputProvider.setDailyData(widget.dailyInput);
                          },
                        ),
                      ),
                    ),
                  ]);
            },
            itemCount: mealNumber.length,
          ),
          lastMeal
              ? const SizedBox(
                  height: 250,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
