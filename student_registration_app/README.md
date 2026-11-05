# Student Registration Web Application (Flutter + SQLite)

Features
- Widgets & layouts: Scaffold, Column, Card, ListView, ListTile, ConstrainedBox
- Input form with validation: name, registration number, email, phone, department, year
- Navigation: Home -> Register -> Students list (Navigator.push)
- Image asset: assets/logo.png
- Animations: logo scale/fade, title slide, list items slide-in, success icon (AnimatedSwitcher)
- SQLite: table `students` (id, name, regNo UNIQUE, email, phone, department, year)

## How to run (Windows / Chrome)
1. Extract the zip, open a terminal inside `student_registration_app`.
2. Generate platform folders (web, android...):
       flutter create .
3. Get packages:
       flutter pub get
4. Set up SQLite for the web (copies sqlite3.wasm + sqflite_sw.js into the web/ folder):
       dart run sqflite_common_ffi_web:setup
5. Run on Chrome (use a FIXED port so the browser keeps your data):
       flutter run -d chrome --web-port 5000

## Things to show in the demo / screenshots
- Home screen (animated logo)
- Register form with validation errors (press Register with empty fields)
- A successful registration
- Students list showing saved records
- Refresh the browser page (F5) -> open View Students -> data is still there (persistent)

## Notes
- On the web, SQLite data is stored inside the browser (IndexedDB) for that address
  (localhost:5000). Clearing browser data or using another port shows an empty database.
- Duplicate registration numbers are rejected (UNIQUE constraint).
- The same code also runs on Android (uses the normal sqflite plugin).
