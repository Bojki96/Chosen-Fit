import 'package:chosen/providers/client.dart';
import 'package:chosen/providers/meals.dart';
import 'package:chosen/services/storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final CollectionReference _clients =
    FirebaseFirestore.instance.collection('clients');

class Database {
  static updateClient({@required Client client}) async {
    await _clients.doc(client.id).update({
      'name': client.name,
      'lastName': client.lastName,
      'email': client.email,
      'phone': client.phone,
      'admin': client.admin,
      'age': client.age,
      'height': client.height
    });
  }

  static getClientData({@required String id}) async {
    Map clientData = await _clients.doc(id).get().then((value) => value.data());
    Client client = Client();

    client.name = clientData['name'];
    client.lastName = clientData['lastName'];
    client.email = clientData['email'];
    client.phone = clientData['phone'];
    client.age = clientData['age'];
    client.height = clientData['height'];
    client.admin = clientData['admin'];
    client.id = id;
    return client;
  }

  static getClients() async {
    List klijenti = [];
    List ids = [];
    List ukupniPodaci = [];
    await _clients
        .orderBy('lastName')
        .get()
        .then((value) => value.docs.forEach((element) {
              if (!element['admin']) {
                klijenti.add(element.data());
                ids.add(element.id);
              }
            }));
    ukupniPodaci = [klijenti, ids];
    return ukupniPodaci;
  }

  static getDailyUpdates({@required String id}) async {
    List dates = [];
    await _clients
        .doc(id)
        .collection('dailyUpdates')
        .orderBy(FieldPath.documentId)
        .get()
        .then((value) => value.docs.forEach((element) {
              dates.add(element.id);
            }));
    return dates;
  }

  static saveMeals(
      {@required String id,
      @required String date,
      @required DailyUpdateInput dailyUpdate}) async {
    await _clients.doc(id).collection('dailyUpdates').doc(date).set(
        {'WaterIntake': dailyUpdate.waterIntake, 'Meals': dailyUpdate.meals});
  }

  static getMeals({@required String id, @required String date}) async {
    bool exists = await _clients
        .doc(id)
        .collection('dailyUpdates')
        .doc(date)
        .get()
        .then((value) => value.exists);

    if (exists) {
      Map meals = await _clients
          .doc(id)
          .collection('dailyUpdates')
          .doc(date)
          .get()
          .then((value) => value.data());
      return meals;
    } else {
      return {'Meals': null, 'WaterIntake': null};
    }
  }

  static getActCode() async {
    return await FirebaseFirestore.instance
        .collection('ChosenCode')
        .doc('Code')
        .get()
        .then((value) => value.get('code'));
  }

  static setActCode({@required String actCode}) async {
    await FirebaseFirestore.instance
        .collection('ChosenCode')
        .doc('Code')
        .update({"code": actCode});
  }

  static getAdmin() async {
    Map admin = {};
    await _clients
        .where('admin', isEqualTo: true)
        .get()
        .then((value) => value.docs.forEach((element) {
              admin = element.data();
            }));
    return admin;
  }

  static uploadWeight(
      {@required String id,
      @required String date,
      @required String weight}) async {
    await _clients
        .doc(id)
        .collection('WeeklyUpdate')
        .doc(date)
        .set({'weight': weight});
  }

  static getWeight({@required String id, @required String date}) async {
    bool weightExists = await _clients
        .doc(id)
        .collection('WeeklyUpdate')
        .doc(date)
        .get()
        .then((value) => value.exists);

    if (weightExists) {
      return await _clients
          .doc(id)
          .collection('WeeklyUpdate')
          .doc(date)
          .get()
          .then((value) => value.data());
    } else {
      return null;
    }
  }

  static getWeeklyDates({@required String id}) async {
    List dates = [];
    await _clients
        .doc(id)
        .collection('WeeklyUpdate')
        .orderBy(FieldPath.documentId)
        .get()
        .then((value) => value.docs.forEach((element) {
              dates.add(element.id);
            }));
    return dates;
  }

  static deleteClient({@required String id}) async {
    await _clients.doc(id).collection('dailyUpdates').get().then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      }
    });
    await _clients.doc(id).collection('WeeklyUpdate').get().then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
      }
    });

    await _clients.doc(id).delete();
  }

  static getClientWeight({@required String id}) async {
    Map weight = {'weight': ''};
    bool exists = await _clients
        .doc(id)
        .collection('WeeklyUpdate')
        .get()
        .then((value) => value.docs.isNotEmpty);
    if (exists) {
      return await _clients.doc(id).collection('WeeklyUpdate').get().then(
          (value) =>
              value.docs.lastWhere((element) => element['weight'] != null));
    } else {
      return weight;
    }
  }

  static getWeightData({@required String id}) async {
    List weight = [];
    List dates = [];
    List data = [];
    DateTime date;
    DateFormat formatDate = DateFormat("yyyy-MM-dd");
    DateFormat datumUString = DateFormat("d.M.yyyy.");
    bool exists = await _clients
        .doc(id)
        .collection('WeeklyUpdate')
        .get()
        .then((value) => value.docs.isNotEmpty);

    if (exists) {
      await _clients
          .doc(id)
          .collection('WeeklyUpdate')
          .get()
          .then((value) => value.docs.forEach((element) {
                if (element.get('weight') != null) {
                  date = formatDate.parse(element.id);
                  String dateString = datumUString.format(date);
                  dates.add(dateString);
                  double weightDouble = double.parse(element.get('weight'));
                  weight.add(weightDouble);
                }
              }));
      data = [dates, weight];
    }

    return data;
  }
}
