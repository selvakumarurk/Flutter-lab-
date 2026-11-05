import 'package:flutter/material.dart';

import 'register_screen.dart';
import 'students_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ANIMATION: logo fades in and scales up
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Transform.scale(scale: value, child: child),
                    );
                  },
                  child: Image.asset('assets/logo.png', height: 150),
                ),
                const SizedBox(height: 16),
                // ANIMATION: title slides up and fades in
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 30 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: const Column(
                    children: [
                      Text(
                        'Student Registration Portal',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Register students and view saved records',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Register Student'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                ),
                const SizedBox(height: 14),
                OutlinedButton.icon(
                  icon: const Icon(Icons.list_alt),
                  label: const Text('View Students'),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(16)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StudentsScreen()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
