import 'package:flutter/material.dart';

class Client with ChangeNotifier {
  Client({this.name, this.lastName});

  String name;
  String lastName;
  String email;
  String password;
  String id;
  String phone;
  bool admin = false;
  String age;
  String height;

  Map _clientData;
  Map get getClientData => _clientData;

  void setClientData(Client client) {
    // _clientData = client;
    _clientData = {
      'name': client.name,
      'lastName': client.lastName,
      'email': client.email,
      'phone': client.phone,
      'admin': client.admin,
      'age': client.age,
      'height': client.height,
      'id': client.id
    };
    notifyListeners();
  }
}

class Slaven with ChangeNotifier {
  Slaven({this.name, this.lastName});
  String name;
  String lastName;
  String email;
  String password;
  String id;
  String phone;
  bool admin = false;
  String age;
  String height;

  Map _SlavenData;
  Map get getSlavenData => _SlavenData;

  void setSlavenData(Client client) {
    _SlavenData = {
      'name': client.name,
      'lastName': client.lastName,
      'email': client.email,
      'phone': client.phone,
      'admin': true,
      'age': client.age,
      'height': client.height,
      'id': client.id
    };
    notifyListeners();
  }
}
