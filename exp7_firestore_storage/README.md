# Experiment 7 - Persistent Storage with Google Cloud Firestore (Flutter)

App: Product Inventory Tracker (Question 1, odd Regno)
Firestore collection: `products`  ->  documents with fields: name, quantity, price, createdAt

## PART A - Create the Flutter platform folders
1. Extract the zip, open a terminal inside `exp7_firestore_storage`.
2. Run:  `flutter create .`      (keeps lib/ and pubspec.yaml, creates android/ etc.)
3. Run:  `flutter pub get`

## PART B - Firebase Console (needs your Google account)
1. Go to https://console.firebase.google.com -> Add project (or use an existing one).
2. Click Add app -> Android (Flutter). The Android package name must match the one in
   `android/app/build.gradle.kts` -> `applicationId` (e.g. com.example.exp7_firestore_storage).
3. Download `google-services.json` and place it in:  `android/app/google-services.json`
4. Build -> Firestore Database -> Create database -> choose "Start in test mode" -> Enable.

## PART C - Gradle settings (as given in the lab sheet)
See GRADLE_SETUP.txt for the exact lines to paste.

## PART D - Run
Start the Android emulator (or connect a phone), then:  `flutter run`

Add a product -> it appears in the Firebase Console under Firestore Database -> products.
Close and reopen the app -> the data is still there (it is stored in the cloud).

## Troubleshooting
- "Firestore error: permission-denied" -> Firestore rules not in test mode (Firestore -> Rules).
- Build error about minSdk / NDK -> redo Part C.
- App crashes at start with "No Firebase App" -> google-services.json missing or in wrong folder.
