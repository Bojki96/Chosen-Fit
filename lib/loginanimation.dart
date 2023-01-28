import 'package:chosen/functions.dart';
import 'package:chosen/providers/error.dart';
import 'package:chosen/services/database.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class LogInOrSignUp extends StatefulWidget {
  String loginOrSignUp;
  bool change;
  Map client;

  LogInOrSignUp(
      {Key key,
      @required this.loginOrSignUp,
      @required this.change,
      this.client})
      : super(key: key);

  @override
  _LogInOrSignUpState createState() => _LogInOrSignUpState();
}

var registerKey = GlobalKey<FormState>();
var loginKey = GlobalKey<FormState>();
var changeDataKey = GlobalKey<FormState>();
double fontSize = 21;

List labelRegistracija = [
  'Ime',
  'Prezime',
  'E-mail',
  'Broj telefona',
  'Godine',
  'Visina [cm]',
  'Lozinka',
  'Potvrda lozinke',
  'Chosen.fit kod'
];

List labelPrijava = [
  'E-mail',
  'Lozinka',
];
List data = [];
List clientData = [null, null, null, null, null, null, null, null, null];
Map controller = Controllers.listOfControllers();
bool removed = false;
bool changed = false;

class _LogInOrSignUpState extends State<LogInOrSignUp> {
  @override
  Widget build(BuildContext context) {
    var errorText = Provider.of<ErrorText>(context);
    double keyboard = MediaQuery.of(context).viewInsets.bottom;

    if (widget.loginOrSignUp == 'prijava') {
      return Form(
        key: loginKey,
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(8, 0, 20, 0),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int i) {
                return Column(
                  children: [
                    Text(
                      '${labelPrijava[i]}:',
                      style: TextStyle(
                          color: Colors.black, fontSize: fontSize + 10),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      textInputAction: labelPrijava[i] == "E-mail"
                          ? TextInputAction.next
                          : TextInputAction.done,
                      autocorrect: false,
                      obscureText: labelPrijava[i] == "Lozinka" ? true : false,
                      keyboardType: labelPrijava[i] == "E-mail"
                          ? TextInputType.emailAddress
                          : TextInputType.text,
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Polje "${labelPrijava[i]}" ne smije biti prazno';
                        } else {
                          if (labelPrijava[i] == 'E-mail') {
                            return EmailValidator(
                                    errorText: 'Netočna E-mail adresa')
                                .call(value);
                          } else {
                            return null;
                          }
                        }
                      },
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          errorText: labelPrijava[i] == 'Lozinka'
                              ? errorText.getErrorPassLogin
                              : errorText.getErrorEmailLogin),
                      style: TextStyle(
                          fontSize: fontSize + 3, color: Colors.black),
                      onSaved: (value) {
                        clientData[i] = value;
                      },
                    ),
                    SizedBox(height: 50)
                  ],
                );
              },
              itemCount: labelPrijava.length,
            ),
            SizedBox(
              height: keyboard > 0 ? 75 : 0,
            )
          ],
        ),
      );
    } else if (widget.loginOrSignUp == 'registracija') {
      if (widget.change && !removed) {
        labelRegistracija.length > 8 ? labelRegistracija.removeAt(8) : null;
        removed = true;

        data = [
          widget.client['name'],
          widget.client['lastName'],
          widget.client['email'],
          widget.client['phone'],
          widget.client['age'],
          widget.client['height'],
        ];
      } else if (removed && !widget.change) {
        labelRegistracija.add('Chosen.fit kod');
        removed = false;
      }
      return Column(
        children: [
          Form(
            key: widget.change ? changeDataKey : registerKey,
            child: ListView.builder(
              itemExtent: 90,
              padding: const EdgeInsets.fromLTRB(8, 0, 20, 0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int i) {
                if (widget.change) {
                  if (!changed) {
                    controller['kontroler$i'].value = controller['kontroler$i']
                        .value
                        .copyWith(text: i < 6 ? data[i] : null);
                  }
                }
                return Column(
                  children: [
                    Text(
                      '${labelRegistracija[i]}:',
                      style: TextStyle(
                          color: Color.fromARGB(255, 95, 60, 146),
                          fontSize: fontSize),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      textInputAction:
                          labelRegistracija[i] == 'Potvrda lozinke' ||
                                  labelRegistracija[i] == 'Chosen.fit kod'
                              ? TextInputAction.done
                              : TextInputAction.next,
                      controller: controller['kontroler$i'],
                      autocorrect: labelRegistracija[i] == "Lozinka" ||
                              labelRegistracija[i] == "Potvrda lozinke"
                          ? false
                          : true,
                      obscureText: labelRegistracija[i] == "Lozinka" ||
                              labelRegistracija[i] == "Potvrda lozinke"
                          ? true
                          : false,
                      keyboardType: labelRegistracija[i] == "E-mail"
                          ? TextInputType.emailAddress
                          : labelRegistracija[i] == "Godine" ||
                                  labelRegistracija[i] == "Visina [cm]"
                              ? TextInputType.number
                              : TextInputType.text,
                      validator: (value) {
                        if (value == null || value == '') {
                          return 'Polje "${labelRegistracija[i]}" ne smije biti prazno';
                        } else {
                          if (labelRegistracija[i] == 'E-mail') {
                            return EmailValidator(
                                    errorText: 'Netočna E-mail adresa')
                                .call(value);
                          } else if (labelRegistracija[i] == 'Lozinka') {
                            return MinLengthValidator(6,
                                    errorText:
                                        'Slaba lozinka: potrebno barem 6 znakova')
                                .call(value);
                          } else if (labelRegistracija[i] ==
                              'Potvrda lozinke') {
                            if (controller['kontroler$i'].text !=
                                controller['kontroler${i - 1}'].text) {
                              return 'Lozinke se ne podudaraju';
                            } else {
                              return null;
                            }
                          } else {
                            return null;
                          }
                        }
                      },
                      decoration: InputDecoration(),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        if (widget.change) {
                          changed = true;
                        }
                        controller['kontroler$i'].value =
                            controller['kontroler$i']
                                .value
                                .copyWith(text: value);
                      },
                      onFieldSubmitted: (value) {
                        controller['kontroler$i'].value =
                            controller['kontroler$i']
                                .value
                                .copyWith(text: value);
                      },
                      onSaved: (value) {
                        changed = false;
                        removed = false;
                        clientData[i] = value;
                      },
                    ),
                  ],
                );
              },
              itemCount: labelRegistracija.length,
            ),
          ),
          SizedBox(
            height: widget.change ? 0 : keyboard + 5,
            child: Text(
              errorText.getErrorEmail ?? '',
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      );
    }
  }
}
