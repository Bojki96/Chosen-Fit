import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';

final storage = firebase_storage.FirebaseStorage.instance.ref('clients');

class FireStorage {
  static uploadImage(
      {@required String id,
      @required String date,
      @required List<File> images}) async {
    for (int i = 0; i < images.length; i++) {
      if (images[i] == null) {
        continue;
      } else {
        await storage.child(id).child(date).child("$i").putFile(images[i]);
      }
    }
  }

  static getImages({@required String id, @required String date}) async {
    List urls = [];
    String url;
    for (int i = 0; i < 3; i++) {
      url = await storage
          .child(id)
          .child(date)
          .child("$i")
          .getDownloadURL()
          .onError((error, stackTrace) => null);
      urls.add(url);
    }
    return urls;
  }
}
