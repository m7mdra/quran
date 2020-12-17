import 'dart:async';

import 'package:path/path.dart';
import 'package:quran/data/model/note.dart';
import 'package:sqflite/sqflite.dart';

import 'note_repository.dart';

class NoteDatabaseClient implements NoteRepository {
  final String tableNote = 'noteTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnContent = 'content';
  final String columnDate = 'date';

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notes.db');

    await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableNote($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnContent TEXT, $columnDate INTEGER)');
  }

  @override
  Future<int> add(Note note) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableNote, note.toMap());

    return result;
  }

  @override
  Future<List<Note>> getAll() async {
    var dbClient = await db;
    var result = await dbClient.query(tableNote,
        columns: [columnId, columnTitle, columnContent, columnDate]);

    return result.map((e) => Note.fromMap(e)).toList();
  }

  @override
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableNote, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateNote(Note note) async {
    var dbClient = await db;
    return await dbClient.update(tableNote, note.toMap(),
        where: "$columnId = ?", whereArgs: [note.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
