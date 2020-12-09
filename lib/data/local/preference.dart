import 'dart:convert';

import 'package:quran/data/local/readers_provider.dart';
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

  Future<Reader> reader() async {
    await _sharedPreferences.reload();
    var json = _sharedPreferences.getString("defaultReader");
    print(json);
    if (json == null) {
      var defaultReader = await _readersProvider.defaultReader();
      await saveReader(defaultReader);
      return defaultReader;
    } else {
      return Reader.fromJson(jsonDecode(json));
    }
  }
}
