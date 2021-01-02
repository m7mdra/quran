import 'dart:convert';

import 'package:quran/data/local/readers_provider.dart';
import 'package:quran/data/model/quran.dart';
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

  Future<void> saveReading(Surah surah, int position) async {
    await _sharedPreferences.setString("last", jsonEncode(surah.toJson()));
    await _sharedPreferences.setInt("position", position);
  }

  Future<MapEntry<int, Surah>> getReading() async {
    await _sharedPreferences.reload();
    var json = _sharedPreferences.getString("last");
    if (json == null) {
      return MapEntry(0, Surah.kTheOpening);
    } else {
      return MapEntry(_sharedPreferences.getInt('position'),
          Surah.fromJson(jsonDecode(json)));
    }
  }

  Future<void> riyadhBookDownloaded() async {
    await _sharedPreferences.setBool("bookDownloaded", true);
  }

  bool didFileDownloadSuccess() {
    return _sharedPreferences.getBool("bookDownloaded") ?? false;
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
