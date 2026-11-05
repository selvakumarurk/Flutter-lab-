import 'package:flutter/material.dart';

import '../db/database_helper.dart';
import '../models/student.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student> _students = [];
  bool _loading = true;
  int _round = 0; // changes so the list animation replays after a reload

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DatabaseHelper.instance.getStudents();
    if (!mounted) return;
    setState(() {
      _students = data;
      _loading = false;
      _round++;
    });
  }

  Future<void> _delete(Student s) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete student?'),
        content: Text('Remove ${s.name} (${s.regNo})?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await DatabaseHelper.instance.deleteStudent(s.id!);
      await _load();
    }
  }

  void _showDetails(Student s) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reg No: ${s.regNo}'),
            Text('Email: ${s.email}'),
            Text('Phone: ${s.phone}'),
            Text('Department: ${s.department}'),
            Text('Year: ${s.year}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Students (${_students.length})'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _students.isEmpty
              ? const Center(child: Text('No students registered yet'))
              : ListView.builder(
                  key: ValueKey(_round),
                  padding: const EdgeInsets.all(12),
                  itemCount: _students.length,
                  itemBuilder: (context, i) {
                    final s = _students[i];
                    // ANIMATION: items slide in and fade in one by one
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 500 + i * 150),
                      curve: Curves.easeOut,
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 40 * (1 - value)),
                          child: child,
                        ),
                      ),
                      child: Card(
                        child: ListTile(
                          onTap: () => _showDetails(s),
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: Text(s.name[0].toUpperCase()),
                          ),
                          title: Text(s.name),
                          subtitle: Text('${s.regNo}  |  ${s.department}  |  ${s.year}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => _delete(s),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
