import 'dart:convert';

import 'package:quran/data/local/readers_provider.dart';
import 'package:quran/data/model/last_read.dart';
import 'package:quran/data/model/reader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preference {
  final SharedPreferences _sharedPreferences;
  final ReadersProvider _readersProvider;

  Preference(this._sharedPreferences, this._readersProvider);

  Future<void> saveReader(Reader reader) async {
    await _sharedPreferences
        .setString("defaultReader", jsonEncode(reader.toJson()))
        .then((value) => print(value));
    return Future.value();
  }

  Future<void> saveReading(LastRead lastRead) async {
    await _sharedPreferences.setString("last", jsonEncode(lastRead.toJson()));
  }

  Future<LastRead> getReading() async {
    await _sharedPreferences.reload();
    var json = _sharedPreferences.getString("last");
    if (json == null) {
      return LastRead.kDefault;
    } else {
      return LastRead.fromJson(
          jsonDecode(_sharedPreferences.getString("last")));
    }
  }

  Future<bool> setDarkTheme() async {
    var saved = await _sharedPreferences.setInt("theme", 2);
    return saved;
  }

  String lang() {
    return _sharedPreferences.getString("lang");
  }

  Future saveCurrentLanguage(String lang) async {
    var saved = await _sharedPreferences.setString("lang", lang);
    return saved;
  }

  Future<bool> setLightTheme() async {
    var saved = await _sharedPreferences.setInt("theme", 1);
    return saved;
  }

  int theme() => _sharedPreferences.getInt("theme") ?? 0;

  Future<void> riyadhBookDownloaded() async {
    await _sharedPreferences.setBool("bookDownloaded", true);
  }

  bool didFileDownloadSuccess() {
    return _sharedPreferences.getBool("bookDownloaded") ?? false;
  }

  Future<void> databaseDownloaded() async {
    await _sharedPreferences.setBool("dbdd", true);
  }

  bool didDatabaseDownloadSuccess() {
    return _sharedPreferences.getBool("dbdd") ?? false;
  }

  Future<Reader> reader() async {
    await _sharedPreferences.reload();
    var json = _sharedPreferences.getString("defaultReader");
    if (json == null) {
      var defaultReader = await _readersProvider.defaultReader();
      await saveReader(defaultReader);
      return defaultReader;
    } else {
      return Reader.fromJson(jsonDecode(json));
    }
  }
}
