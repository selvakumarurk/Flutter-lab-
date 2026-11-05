import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/inventory_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String? initError;
  try {
    // Reads the settings from android/app/google-services.json
    await Firebase.initializeApp();
  } catch (e) {
    initError = e.toString();
  }

  runApp(MyApp(initError: initError));
}

class MyApp extends StatelessWidget {
  final String? initError;
  const MyApp({super.key, this.initError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Inventory Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initError == null
          ? const InventoryScreen()
          : Scaffold(
              appBar: AppBar(title: const Text('Firebase setup problem')),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    'Firebase could not start.\n\n'
                    'Check that google-services.json is in android/app/ and the '
                    'Gradle setup is done.\n\nError:\n$initError',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ),
    );
  }
}
