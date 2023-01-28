import 'package:chosen/providers/client.dart';
import 'package:chosen/services/connectivity.dart';
import 'package:chosen/services/database.dart';
import 'package:chosen/services/sharedpreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final CollectionReference _clients =
    FirebaseFirestore.instance.collection('clients');

class Auth {
  static logIn({
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'E-mail ne postoji';
        //'E-mail doesn\'t exist';
      } else if (e.code == 'wrong-password') {
        return 'Netočna lozinka';
        //'Wrong password';
      } else {
        return 'Neuspješna prijava, pokušajte ponovno';
        //'Login failed';
      }
    }
  }

  static newClient({@required Client client, @required String actCode}) async {
    //https://medium.com/firebase-developers/patterns-for-security-with-firebase-offload-client-work-to-cloud-functions-7c420710f07

    String error;
    UserCredential userCred;
    Map<String, dynamic> data = <String, dynamic>{
      'name': client.name,
      'lastName': client.lastName,
      'email': client.email,
      'phone': client.phone,
      'admin': client.admin,
      'age': client.age,
      'height': client.height
    };
    try {
      userCred = await auth.createUserWithEmailAndPassword(
          email: client.email, password: client.password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        error = 'Netočan E-mail!';
        //'E-mail is not valid';
      } else if (e.code == 'email-already-in-use') {
        error = 'E-mail se već koristi!';
        //'E-mail already in use';
      } else if (e.code == 'weak-password') {
        error = 'Slaba lozinka: potrebno barem 6 znakova!';
        //'Weak password: 6 characters at least';
      } else {
        error = 'Neuspješna registracija, pokušajte ponovno';
        //'Failed registration';
      }
    }

    if (error != 'Netočan E-mail' &&
        error != 'E-mail se već koristi' &&
        error != 'Slaba lozinka: potrebno barem 6 znakova' &&
        error != 'Neuspješna registracija, pokušajte ponovno') {
      client.id = userCred.user.uid;
      String code = await Database.getActCode();
      if (actCode == code) {
        await _clients
            .doc(client.id)
            .set(data)
            .whenComplete(() =>
                print('${client.name} ${client.lastName} je dodan u bazu'))
            .catchError((e) => print(e));

        userCred.user.updateDisplayName(client.name);
        userCred.user.sendEmailVerification();
        return userCred;
      } else {
        await userCred.user.delete();
        error = 'Netočan aktivacijski kod!';
        return error;
      }
    } else {
      return error;
    }
  }

  static reauthenticate() async {
    List<String> reauth = await LocalStorage.getAuth();
    AuthCredential credential =
        EmailAuthProvider.credential(email: reauth[0], password: reauth[1]);
    await FirebaseAuth.instance.currentUser
        .reauthenticateWithCredential(credential);
  }

  static updateEmail({@required String newEmail}) async {
    String error = '';

    try {
      await auth.currentUser.updateEmail(newEmail).then(
            (value) => print('Uspješno izmjenjen e-mail'),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        error = 'E-mail se već koristi!';
      } else {
        error =
            'Neuspješna promjena E-mail adrese, pokušajte se odjaviti i ponovno prijaviti';
      }
    }
    return error;
  }

  static updatePassword({@required String newPassword}) async {
    String error = '';

    try {
      await auth.currentUser.updatePassword(newPassword).then(
            (value) => print('Uspješno izmjenjen password'),
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'Slaba lozinka: potrebno barem 6 znakova!';
      } else {
        error =
            'Neuspješna promjena lozinke, probajte se odjaviti i ponovno prijaviti';
      }
    }
    return error;
  }

  static checkEmailVerified() async {
    User user = auth.currentUser;
    await user.reload();
    return user.emailVerified;
  }

  static Future<String> autoLogIn() async {
    Client client = Client();
    User user = FirebaseAuth.instance.currentUser;
    bool status = await Connection.initConnectivity();
    if (user == null) {
      if (status) {
        return '/prijava2';
      } else {
        return '/nointernet';
      }
    } else {
      if (status) {
        String id = user.uid;
        client = await Database.getClientData(id: id);
        if (client.admin) {
          return '/clients';
        } else {
          return '/profil';
        }
      } else {
        return '/nointernet';
      }
    }
  }

  static forgottenPassword({@required String email}) async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .onError((error, stackTrace) => print(error));
  }

  static signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
