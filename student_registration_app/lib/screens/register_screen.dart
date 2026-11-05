import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/student.dart';
import 'students_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _regNo = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();

  final _departments = const ['CSE', 'CSE(AIML)', 'IT', 'ECE', 'EEE', 'MECH', 'CIVIL'];
  final _years = const ['I Year', 'II Year', 'III Year', 'IV Year'];

  String? _department;
  String? _year;
  bool _saving = false;
  bool _saved = false; // used for the success animation

  @override
  void dispose() {
    _name.dispose();
    _regNo.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  // ---------- Validators ----------
  String? _validateName(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Name is required';
    if (s.length < 3) return 'Name must be at least 3 characters';
    if (!RegExp(r'^[A-Za-z .]+$').hasMatch(s)) return 'Name can contain only letters';
    return null;
  }

  String? _validateRegNo(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Registration number is required';
    if (!RegExp(r'^[A-Za-z0-9]{6,15}$').hasMatch(s)) {
      return 'Enter 6-15 letters/digits (e.g. URK23CS1001)';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w.\-]+@[\w\-]+(\.[\w\-]+)+$').hasMatch(s)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    final s = v?.trim() ?? '';
    if (s.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(s)) {
      return 'Enter a valid 10-digit mobile number';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    try {
      await DatabaseHelper.instance.insertStudent(Student(
        name: _name.text.trim(),
        regNo: _regNo.text.trim().toUpperCase(),
        email: _email.text.trim(),
        phone: _phone.text.trim(),
        department: _department!,
        year: _year!,
      ));

      if (!mounted) return;
      _formKey.currentState!.reset();
      _name.clear();
      _regNo.clear();
      _email.clear();
      _phone.clear();
      setState(() {
        _department = null;
        _year = null;
        _saved = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student registered successfully')),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _saved = false);
      });
    } catch (e) {
      if (!mounted) return;
      final duplicate = e.toString().toUpperCase().contains('UNIQUE');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(duplicate
              ? 'This registration number is already registered'
              : 'Could not save: $e'),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Student'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ANIMATION: success icon switches in with a scale transition
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: _saved
                        ? const Icon(Icons.check_circle,
                            key: ValueKey('saved'), size: 60, color: Colors.green)
                        : const Icon(Icons.school,
                            key: ValueKey('form'), size: 60, color: Colors.indigo),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Student Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateName,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _regNo,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Registration Number',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateRegNo,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      counterText: '',
                    ),
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _department,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      prefixIcon: Icon(Icons.apartment),
                      border: OutlineInputBorder(),
                    ),
                    items: _departments
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) => setState(() => _department = v),
                    validator: (v) => v == null ? 'Select a department' : null,
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _year,
                    decoration: const InputDecoration(
                      labelText: 'Year of Study',
                      prefixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    items: _years
                        .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                        .toList(),
                    onChanged: (v) => setState(() => _year = v),
                    validator: (v) => v == null ? 'Select the year of study' : null,
                  ),
                  const SizedBox(height: 22),
                  ElevatedButton.icon(
                    onPressed: _saving ? null : _submit,
                    icon: const Icon(Icons.save),
                    label: Text(_saving ? 'Saving...' : 'Register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StudentsScreen()),
                    ),
                    child: const Text('View registered students'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
