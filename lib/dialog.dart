import 'package:chosen/providers/chosencode.dart';
import 'package:chosen/services/auth.dart';
import 'package:chosen/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogChosen extends StatelessWidget {
  DialogChosen({
    Key key,
    this.fontSize,
    @required this.changeCode,
    this.forgetPassword,
    this.imeIprezime,
    this.activationCode,
  }) : super(key: key);

  String activationCode;
  bool forgetPassword;
  bool changeCode;
  String imeIprezime;
  final double fontSize;
  String hintText;
  TextEditingController kod = TextEditingController();
  TextEditingController email = TextEditingController();
  String title;
  List<String> buttonText = ['', ''];
  final _activationKey = GlobalKey<FormState>();
  final _forgotPassKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var actCode = Provider.of<Code>(context);
    if (changeCode) {
      title = 'Upiši novi aktivacijski kod';
      buttonText[0] = 'Postavi';
      buttonText[1] = 'Otkaži';
      hintText = actCode.getActCode ?? activationCode;
    } else {
      if (forgetPassword) {
        title = 'Upišite E-mail adresu i stisnite na link kada primite E-mail';
        buttonText[0] = 'Pošalji';
        buttonText[1] = 'Otkaži';
        hintText = 'E-mail';
      } else {
        title = 'Jesi li siguran da želiš ukloniti "$imeIprezime"?';
        buttonText[0] = 'Da';
        buttonText[1] = 'Ne';
      }
    }

    return AlertDialog(
      backgroundColor: Color.fromARGB(255, 95, 60, 146).withOpacity(0.9),
      title: Text(
        title,
        style: TextStyle(fontSize: fontSize - 1, color: Colors.white),
      ),
      content: !changeCode && !forgetPassword
          ? null
          : Form(
              key: changeCode
                  ? _activationKey
                  : forgetPassword
                      ? _forgotPassKey
                      : null,
              child: TextFormField(
                validator: (value) {
                  if (value == '' || value == null || value == ' ') {
                    if (forgetPassword) {
                      return 'Upišite E-mail adresu';
                    } else {
                      return 'Unesi slova i/ili brojke!';
                    }
                  } else {
                    return null;
                  }
                },
                controller: changeCode
                    ? kod
                    : forgetPassword
                        ? email
                        : null,
                style: TextStyle(fontSize: fontSize),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(8.0),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple[800]),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                  errorStyle:
                      TextStyle(fontSize: fontSize - 6, color: Colors.red),
                  hintText: hintText,
                ),
              ),
            ),
      actions: [
        TextButton(
            onPressed: () {
              if (changeCode) {
                if (_activationKey.currentState.validate()) {
                  Database.setActCode(actCode: kod.value.text);
                  actCode.setActCode(kod.value.text);
                  Navigator.pop(context);
                }
              } else {
                if (forgetPassword) {
                  if (_forgotPassKey.currentState.validate()) {
                    Auth.forgottenPassword(email: email.value.text);
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context, true);
                }
              }
            },
            style: TextButton.styleFrom(backgroundColor: Colors.white),
            child: Container(
                alignment: Alignment.center,
                width: !changeCode && !forgetPassword ? 45 : 65,
                height: 25,
                child: Text(
                  buttonText[0],
                  style: TextStyle(
                      fontSize: fontSize - 4,
                      color: Color.fromARGB(255, 95, 60, 146)),
                ))),
        Container(
          alignment: Alignment.center,
          width: !changeCode && !forgetPassword ? 45 : 100,
          height: 45,
          child: TextButton(
            onPressed: () {
              if (changeCode) {
                Navigator.pop(context);
              } else {
                if (forgetPassword) {
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context, false);
                }
              }
            },
            style: TextButton.styleFrom(
              side: BorderSide.none,
            ),
            child: Text(
              buttonText[1],
              style: TextStyle(fontSize: fontSize - 4, color: Colors.white),
            ),
          ),
        )
      ],
      elevation: 30.0,
    );
  }
}
