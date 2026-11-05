import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/student.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  Future<Database> get database async => _db ??= await _init();

  // Create database + table
  Future<Database> _init() async {
    // On the web SQLite runs through sqlite3.wasm (stored in the browser).
    // On Android / iOS the normal sqflite plugin is used.
    final DatabaseFactory factory =
        kIsWeb ? databaseFactoryFfiWebNoWebWorker : databaseFactory;
    final String path =
        kIsWeb ? 'students.db' : join(await getDatabasesPath(), 'students.db');

    return factory.openDatabase(
      path,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE students (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              regNo TEXT NOT NULL UNIQUE,
              email TEXT NOT NULL,
              phone TEXT NOT NULL,
              department TEXT NOT NULL,
              year TEXT NOT NULL
            )
          ''');
        },
      ),
    );
  }

  // CREATE
  Future<int> insertStudent(Student s) async {
    final db = await database;
    return db.insert('students', s.toMap()..remove('id'));
  }

  // READ
  Future<List<Student>> getStudents() async {
    final db = await database;
    final rows = await db.query('students', orderBy: 'id DESC');
    return rows.map(Student.fromMap).toList();
  }

  // UPDATE
  Future<int> updateStudent(Student s) async {
    final db = await database;
    return db.update('students', s.toMap(), where: 'id = ?', whereArgs: [s.id]);
  }

  // DELETE
  Future<int> deleteStudent(int id) async {
    final db = await database;
    return db.delete('students', where: 'id = ?', whereArgs: [id]);
  }
}
