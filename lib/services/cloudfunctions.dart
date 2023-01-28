import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

class CloudFunctions {
  static deleteUser({@required String uid}) async {
    await FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('deleteUser')
        .call(<String, String>{
      'text': uid,
    });
  }

  static deleteImages({@required String uid}) async {
    await FirebaseFunctions.instanceFor(region: 'europe-west1')
        .httpsCallable('deleteImages')
        .call(<String, String>{
      'uid': uid,
    });
  }
}
