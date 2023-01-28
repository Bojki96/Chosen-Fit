# Chosen.fit

# Getting started
1) Install Flutter (https://docs.flutter.dev/get-started/install). For this project Flutter version is 2.10.5 and make sure everything is set correctrly (run "flutter doctor" to check)
2) Run command "flutter pub get" to get packages
3) Run command "flutter devices" to check connected devices
4) Optionally connect your smartphone to a computer, or run a simulator (android, ios)
5) Run command "flutter run -d {connected-device-name}" to check if current settings of the app can be build
6) Fix errors 😉 (if there are any)
7) Change bundleID and package name "com.bdapp.chosenfit" to your preferences
8) For backend everything is set for Firebase usage, create project on Firebase and add:
        - firestore database
        - firebase authentication
        - firebase storage
        - firebase functions (firebase folder in this project)
        (https://firebase.flutter.dev/docs/overview/)
9) Connect Firebase project to Flutter app, follow the instructions on Firebase (add and change google-services.json to android and ios folders)
10) Run command "flutter run -d {device-name}"
