import 'package:chosen/providers/imagepicker.dart';
import 'package:chosen/providers/meals.dart';
import 'package:chosen/services/database.dart';
import 'package:chosen/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'clip.dart';
import 'package:chosen/screens/dailyupdate.dart';
import 'package:intl/intl.dart';

class Buttons extends StatelessWidget {
  String gumb;
  String date;
  Function loadingWidgetCallBack;
  String pickingImage;

  Buttons({
    Key key,
    @required this.gumb,
    this.date,
    this.loadingWidgetCallBack,
    this.pickingImage,
  }) : super(key: key);
  DailyUpdateInput dailyUpdateInput = DailyUpdateInput();
  DateFormat datumUBazu = DateFormat("d.M.yyyy.");
  DateFormat formatDate = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    var dailyInput = Provider.of<DailyUpdateInput>(context);
    var pickedImage = Provider.of<ChooseImage>(context, listen: false);

    if (gumb == 'Back') {
      return Align(
        alignment: Alignment.topRight,
        child: ClipPath(
          clipper: ButtonClipper(nazivGumba: 'Back'),
          child: Container(
            alignment: Alignment.centerRight,
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 95, 60, 146),
                shape: BoxShape.circle),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:
                    const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
          ),
        ),
      );
    } else if (gumb == 'Save') {
      return Align(
        alignment: pickingImage != null
            ? Alignment.bottomCenter
            : Alignment.bottomRight,
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, pickingImage != null ? 0 : 10,
              pickingImage != null ? 20 : 10),
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(0, 0, 7, 10),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 95, 60, 146), shape: BoxShape.circle),
          child: IconButton(
              onPressed: () async {
                String id = FirebaseAuth.instance.currentUser.uid;
                if (pickingImage != null) {
                  loadingWidgetCallBack(true);
                  await FireStorage.uploadImage(
                      id: id, date: date, images: pickedImage.getImages);
                  String nedjeljaUBazu =
                      formatDate.format(datumUBazu.parse(date));
                  await Database.uploadWeight(
                      id: id,
                      date: nedjeljaUBazu,
                      weight: dailyInput.getWeight);
                  loadingWidgetCallBack(false);
                  Navigator.pop(context);
                } else {
                  loadingWidgetCallBack(true);
                  dailyUpdateKey.currentState.save();
                  dailyUpdateInput.meals = dailyInput.getDailyUpdate['Meals'];
                  dailyUpdateInput.waterIntake =
                      dailyInput.getDailyUpdate['WaterIntake'];
                  await Database.saveMeals(
                      id: id, date: date, dailyUpdate: dailyUpdateInput);
                  await Future.delayed(const Duration(seconds: 1));
                  loadingWidgetCallBack(false);
                  Navigator.pop(context);
                }
              },
              icon: Icon(
                Icons.backup_outlined,
                color: Colors.white,
                size: 40,
              )),
        ),
      );
    } else {
      return Align(
          //ADD BUTTON
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0, 0, 5, 8),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 95, 60, 146),
                shape: BoxShape.circle),
            child: IconButton(
              onPressed: () {
                dailyInput.mealAddedAfterWhile(true);
                dailyInput.addMeal(dailyInput.getMealNumber.length);
              },
              icon: Icon(Icons.add_outlined, color: Colors.white, size: 40),
            ),
          ));
    }
  }
}
