import 'dart:async';

import 'package:path/path.dart';
import 'package:quran/data/local/bookmark_repository.dart';
import 'package:quran/data/model/bookmark.dart';
import 'package:quran/data/model/note.dart';
import 'package:sqflite/sqflite.dart';

import 'note_repository.dart';

class QuranDatabaseClient implements NoteRepository, BookmarkRepository {
  Database _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    // lazily instantiate the db the first time it is accessed
    await initDb();
    _db = await _openDatabase();
    return _db;
  }

  Future _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "meta.db");
    print("open database");
    return await openDatabase(path, readOnly: false);
  }


  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'meta.db');
    var exists = await databaseExists(path);
    if(!exists) {
      await deleteDatabase(path); // just for testing
     await openDatabase(path, version: 1, onCreate: _onCreate);
      
    }
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('CREATE TABLE ${NoteColumns.table}'
        '(${NoteColumns.columnId} INTEGER PRIMARY KEY,'
        ' ${NoteColumns.columnTitle} TEXT,'
        ' ${NoteColumns.columnContent} TEXT,'
        ' ${NoteColumns.columnDate} INTEGER)');

    await db.execute('CREATE TABLE ${BookmarkColumns.table}'
        '(${BookmarkColumns.columnId} INTEGER PRIMARY KEY,'
        ' ${BookmarkColumns.columnSurah} INTEGER,'
        ' ${BookmarkColumns.columnName} TEXT,'
        ' ${BookmarkColumns.columnDate} INTEGER)');
  }

  @override
  Future<int> add(Note note) async {
    var dbClient = await database;
    var result = await dbClient.insert(NoteColumns.table, note.toMap());

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
