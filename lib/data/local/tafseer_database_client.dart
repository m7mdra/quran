import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:quran/data/local/tafseer_repository.dart';
import 'package:quran/data/model/tafseer.dart';
import 'package:sqflite/sqflite.dart';

class TafseerDataBaseClient implements TafseerRepository {
  var _databaseName = "QuranData.sqlite";

  // only have a single app-wide reference to the database
   Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    await initDatabase();
    _database = await _openDatabase();
    return _database;
  }

  Future _openDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this._databaseName);
    print("open database");
    return await openDatabase(path, readOnly: false);
  }

  Future initDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, this._databaseName);
    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
        // Copy from asset
        ByteData data =
            await rootBundle.load(join("assets/data", this._databaseName));

        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

        // Write and flush the bytes written
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (error) {
        print(error);
      }
    } else {
      print("Opening existing database");
    }
  }

  @override
  Future<Tafseer> getSingleTafseer(int ayahId) async {
    try {
      var db = await database;
      var query = await db
          .rawQuery("SELECT  * FROM moyassar_ayat_Test WHERE AyaID = $ayahId");
      List<Tafseer> list = [];
      query.forEach((element) {
        list.add(Tafseer.fromMap(element));
      });
      return list.first;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<Tafseer>> getSurahTafseer(int start, int end) async {
    try {
      var db = await database;
      var query = await db.rawQuery(
          "SELECT * FROM moyassar_ayat_Test WHERE AyaID  BETWEEN $start AND $end;  ");
      List<Tafseer> list = [];
      query.forEach((element) {
        list.add(Tafseer.fromMap(element));
      });
      return list;
    } catch (error) {
      throw error;
    }
  }
}