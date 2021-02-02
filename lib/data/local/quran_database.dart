import 'package:quran/data/local/database_file.dart';
import 'package:sqflite/sqflite.dart';

import 'model/ayah.dart';
import 'model/edition.dart';
import 'model/surah.dart';

class QuranDatabase {
  final DatabaseFile databaseFile;
  Database _db;

  QuranDatabase(this.databaseFile);

  initDb() async {
    String dbPath = await databaseFile.databasePath();

    return await openDatabase(dbPath);
  }

  Future<Database> get database async {
    if (_db != null) return _db;

    _db = await initDb();
    return _db;
  }

  Future<List<Surah>> surat() async {
    var db = await database;
    var query = await db.rawQuery('SELECT * FROM surat');
    return query.map((e) => Surah.fromMap(e)).toList();
  }

  Future<List<Edition>> editions() async {
    var db = await database;
    var query = await db.rawQuery('SELECT * FROM edition');
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Edition>> quranEditions() async {
    var db = await database;
    var query =
        await db.rawQuery('SELECT * FROM edition where type =?', ['quran']);
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Edition>> tafseerEditions() async {
    var db = await database;
    var query =
        await db.rawQuery('SELECT * FROM edition where type =?', ['tafseer']);
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Edition>> translationEditions() async {
    var db = await database;
    var query = await db
        .rawQuery('SELECT * FROM edition where type =?', ['translation']);
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Edition>> verseByVerseEditions() async {
    var db = await database;
    var query = await db
        .rawQuery('SELECT * FROM edition where type =?', ['versebyverse']);
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Ayah>> ayat([int editionId = 82]) async {
    var db = await database;
    var query = await db
        .rawQuery('SELECT * FROM ayat where edition_id =?', [editionId]);
    return query.map((e) => Ayah.fromMap(e)).toList();
  }


}
