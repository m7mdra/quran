import 'dart:async';

import 'package:path/path.dart';
import 'package:quran/data/local/bookmark_repository.dart';
import 'package:quran/data/model/bookmark.dart';
import 'package:quran/data/model/note.dart';
import 'package:quran/data/model/reminder.dart';
import 'package:sqflite/sqflite.dart';

import 'note_repository.dart';

class QuranMetaDatabase implements NoteRepository, BookmarkRepository {
  Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;

    _db = await initDb();
    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'meta.db');
    return await openDatabase(path,
        version: 3,
        onCreate: _onCreate,
        onUpgrade: (database, newVersion, oldVersion) {});
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE ${NoteColumns.table}'
        '(${NoteColumns.columnId} INTEGER PRIMARY KEY,'
        ' ${NoteColumns.columnTitle} TEXT,'
        ' ${NoteColumns.columnContent} TEXT,'
        ' ${NoteColumns.columnDate} INTEGER)');

    await db.execute('CREATE TABLE ${BookmarkColumns.table}'
        '(${BookmarkColumns.columnId} INTEGER PRIMARY KEY,'
        ' ${BookmarkColumns.columnPage} INTEGER,'
        ' ${BookmarkColumns.columnName} TEXT,'
        ' ${BookmarkColumns.columnDate} INTEGER)');

    await db.execute('CREATE TABLE ${ReminderColumns.table}'
        '(${ReminderColumns.columnId} INTEGER PRIMARY KEY,'
        ' ${ReminderColumns.columnCompleted} INTEGER,'
        ' ${ReminderColumns.columnName} TEXT,'
        ' ${ReminderColumns.columnDate} INTEGER)');
  }

  @override
  Future<int> add(Note note) async {
    var dbClient = await database;
    var result = await dbClient.insert(NoteColumns.table, note.toMap());

    return result;
  }

  Future<List<Reminder>> getReminders() async {
    var dbClient = await database;
    var result = await dbClient.query(ReminderColumns.table,
        columns: ReminderColumns.columns);
    return result.map((e) => Reminder.fromMap(e)).toList();
  }

  Future<int> completeReminder(int id) async {
    var dbClient = await database;
    var result = await dbClient.update(
        ReminderColumns.table, {ReminderColumns.columnCompleted: '1'},
        where: '${ReminderColumns.columnId} = ?', whereArgs: [id]);
    print("completeReminder: $result");
    return result;
  }

  Future<int> addReminder(Reminder reminder) async {
    var dbClient = await database;
    var result = await dbClient.insert(ReminderColumns.table, reminder.toMap());
    return result;
  }

  @override
  Future<List<Note>> getAll() async {
    var dbClient = await database;
    var result =
        await dbClient.query(NoteColumns.table, columns: NoteColumns.columns);
    return result.map((e) => Note.fromMap(e)).toList();
  }

  @override
  Future<int> delete(int id) async {
    var dbClient = await database;
    return await dbClient.delete(NoteColumns.table,
        where: '${NoteColumns.columnId} = ?', whereArgs: [id]);
  }

  Future<int> updateNote(Note note) async {
    var dbClient = await database;
    return await dbClient.update(NoteColumns.table, note.toMap(),
        where: "${NoteColumns.columnId} = ?", whereArgs: [note.id]);
  }

  Future close() async {
    var dbClient = await database;
    return dbClient.close();
  }

  @override
  Future<int> addBookmark(Bookmark bookmark) async {
    var dbClient = await database;
    var result = await dbClient.insert(BookmarkColumns.table, bookmark.toMap());
    return result;
  }

  @override
  Future<int> deleteBookmark(int id) async {
    var dbClient = await database;
    return await dbClient.delete(BookmarkColumns.table,
        where: '${BookmarkColumns.columnId} = ?', whereArgs: [id]);
  }

  @override
  Future<List<Bookmark>> getBookmarks() async {
    var dbClient = await database;
    var result = await dbClient.query(BookmarkColumns.table,
        columns: BookmarkColumns.columns);
    return result.map((e) => Bookmark.fromMap(e)).toList();
  }
}
