const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp({
  storageBucket: "chosen-9b16a.appspot.com",
});


exports.deleteUser = functions.region('europe-west1').https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "samo korisnik app može izbrisati"
    );
  } else {
    const uid = data.text;
    admin
      .auth()
      .deleteUser(uid)
      .then(function () {
        console.log("Uspješno izbrisan klijent");
      })
      .catch(function (error) {
        console.log("Klijent možda ne postoji");
      });
    return null;
  }
});

exports.deleteImages = functions.region('europe-west1').https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "samo korisnik app može izbrisati"
    );
  } else {
    const bucket = admin.storage().bucket();
      await bucket.deleteFiles({
        prefix: `clients/${data.uid}`
    });
  }
});