import 'package:path/path.dart';
import 'package:quran/data/local/database_file.dart';
import 'package:sqflite/sqflite.dart';

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

}
