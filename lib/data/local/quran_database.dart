import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:quran/common.dart';
import 'package:quran/data/local/database_file.dart';
import 'package:quran/data/local/model/hizb_quarter.dart';
import 'package:sqflite/sqflite.dart';

import 'model/ayah.dart';
import 'model/edition.dart';
import 'model/juz.dart';
import 'model/search_result.dart';
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
    var query = await db.rawQuery("""
    SELECT surat.id,
    surat.name,
    surat.englishname,
    surat.englishtranslation,
    surat.revelationCity,
    surat.numberOfAyats,
    ayat.page_id
    FROM   surat
    LEFT JOIN ayat
    ON surat.id = ayat.surat_id
    GROUP  BY surat.id  
    """);
    return query.map((e) => Surah.fromMap(e)).toList();
  }

  Future<List<Surah>> surahById(int id) async {
    var db = await database;
    var query = await db.rawQuery('SELECT * FROM surat where id = ?', [id]);
    return query.map((e) => Surah.fromMap(e)).toList();
  }

  Future<List<Edition>> editions() async {
    var db = await database;
    var query = await db.rawQuery('SELECT * FROM edition');
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Ayah>> page(int page) async {
    var db = await database;
    var query =
        await db.rawQuery('SELECT * FROM ayat where page_id = ?', [page]);
    return query.map((e) => Ayah.fromMap(e)).toList();
  }

  Future<List<Edition>> quranEditions() async {
    var db = await database;
    var query =
        await db.rawQuery('SELECT * FROM edition WHERE type =?', ['quran']);
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Edition>> tafseerEditions() async {
    var db = await database;
    var query =
        await db.rawQuery('SELECT * FROM edition WHERE type =?', ['tafseer']);
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Edition>> translationEditions() async {
    var db = await database;
    var query = await db
        .rawQuery('SELECT * FROM edition WHERE type =?', ['translation']);
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<List<Edition>> verseByVerseEditions() async {
    var db = await database;
    var query = await db
        .rawQuery('SELECT * FROM edition WHERE type =?', ['versebyverse']);
    return query.map((e) => Edition.fromMap(e)).toList();
  }

  Future<Map<int, List<Ayah>>> ayat([int editionId = 82]) async {
    var db = await database;
    var query = await db.rawQuery(""" 
       SELECT ayat.id,
       ayat.surat_id,
       ayat.edition_id,
       ayat.number,
       ayat.text,
       ayat.numberinsurat,
       ayat.page_id,
       surat.name AS surat_name
       FROM ayat
       LEFT JOIN surat
       ON surat.id = ayat.surat_id
       WHERE  edition_id = ? """, [editionId]);
    var list = query.map((e) => Ayah.fromMap(e)).toList();
    var ayatByPage = groupBy(list, (ayah) => ayah.pageId).map((key, value) => MapEntry(key as int, value));
    return ayatByPage;
  }

  Future<Map<int, List<JuzReference>>> juz() async {
    var db = await database;

    var queries = List.generate(30, (index) => index).map((e) => db.rawQuery("""
        SELECT ayat.surat_id,ayat.juz_id, ayat.id, ayat.numberinsurat ,ayat.text, surat.name,ayat.page_id
        FROM ayat 
        LEFT OUTER JOIN surat
        on ayat.surat_id = surat.id
        WHERE juz_id = ${e + 1} and edition_id = 77
        GROUP BY ayat.surat_id
        """));
    var result = await Future.wait(queries);
    var flatResult = flatten(result);

    var list = flatResult.map((e) => JuzReference.fromMap(e)).toList();

    var juzes = groupBy<JuzReference, int>(list, (juz) => juz.juzId);

    return juzes;
  }

  Future<List<HizbQuarter>> hizbQuarter() async {
    var db = await database;

    var query = await db.rawQuery("""
        SELECT  ayat.hizbQuarter_id,ayat.page_id from ayat 
        LEFT JOIN hizb_quarter
        ON ayat.hizbQuarter_id = hizb_quarter.id
        LEFT JOIN  surat
        ON ayat.surat_id = surat.id
        WHERE ayat.edition_id = 78
        GROUP BY ayat.hizbQuarter_id
        """);

    return query.map((e) => HizbQuarter.fromMap(e)).toList();
  }

  Future<List<SearchResult>> search(String keyword) async {
    var db = await database;
    var query = await db.rawQuery("""
    SELECT *  FROM ayat
    LEFT  OUTER JOIN  surat
    ON ayat.surat_id = surat.id
    WHERE  ayat.edition_id = 78 AND text LIKE '%$keyword%' """);
    return query.map((e) => SearchResult.fromMap(e)).toList();
  }

  Future<List<Ayah>> singleTafseer(
      {@required int id, int editionId = 103}) async {
    var db = await database;
    var query = await db.rawQuery(
        'SELECT *  FROM ayat WHERE ayat.number = ? and ayat.edition_id = ?',
        [id, editionId]);
    return query.map((e) => Ayah.fromMap(e)).toList();
  }

  Future<List<Ayah>> rangedTafseer(
      {@required int startId, @required int endId, int editionId = 103}) async {
    var db = await database;
    var query = await db.rawQuery(
        'SELECT *  FROM ayat WHERE ayat.number BETWEEN ? and ? and ayat.edition_id = ?',
        [startId, endId, editionId]);
    return query.map((e) => Ayah.fromMap(e)).toList();
  }

  Future<List<Ayah>> pageTafseer(
      {@required int page, int editionId = 103}) async {
    var db = await database;
    var query = await db.rawQuery(
        'SELECT * FROM ayat WHERE ayat.page_id = ? and ayat.edition_id = ?',
        [page, editionId]);

    return query.map((e) => Ayah.fromMap(e)).toList();
  }
}
