# Ex. 8 - Searching Information in Google Firestore Database (Flutter)

Searches the `students` collection by exact name or registration number and shows
name, registration number, department and marks.

## 1. Create platform folders
Extract the zip, open a terminal in `ex8_firestore_search`, then:

    flutter create .
    flutter pub get

## 2. Connect Firebase (generates lib/firebase_options.dart)
You can reuse the same Firebase project you made for Exp 7.

    dart pub global activate flutterfire_cli
    firebase login
    flutterfire configure

(`firebase login` needs Node.js + `npm install -g firebase-tools`.)
Choose your Firebase project and tick the platforms you will run on (Web / Android).
This REPLACES the placeholder lib/firebase_options.dart.

## 3. Firestore
Firebase Console -> Build -> Firestore Database -> Create database -> Start in test mode.
Then add the `students` documents described in SAMPLE_DATA.txt.

## 4. Run
    flutter run -d chrome

Search a name or registration number exactly as stored (case-sensitive).
