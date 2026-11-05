# Ex. No. 9 – Update Information in Google Firestore Database
24CS2016 – Building Applications using Flutter | REGNO: URK23CS5096

## Setup (one time)

1. Unzip this folder and open it in VS Code (File > Open Folder).
2. Open the VS Code terminal in the project folder and generate the platform folders
   (android, web, ios, etc.). Your existing lib/ and pubspec.yaml are kept:

       flutter create .

3. Install packages:

       flutter pub get

4. Connect Firebase (this replaces lib/firebase_options.dart with your real keys):

       dart pub global activate flutterfire_cli
       flutterfire configure

   Choose your Firebase project and select the platforms (Web / Android).

5. In the Firebase Console > Firestore Database, create a collection `students`.
   Each document ID = registration number (e.g. URK23CS7012) with fields:

       name        (string)
       department  (string)
       marks       (number)

6. Firestore Rules (for testing only):

       rules_version = '2';
       service cloud.firestore {
         match /databases/{database}/documents {
           match /students/{id} {
             allow read, write: if true;
           }
         }
       }

## Run

    flutter run -d chrome

or press F5 in VS Code and pick Chrome / your device.
