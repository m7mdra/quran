import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:quran/data/model/quran.dart';

class DuaMathor {
  String value;

  DuaMathor({this.value});

  DuaMathor.fromJson(dynamic json) {
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["value"] = value;
    return map;
  }
}

void main() {
  var file = File(
      '/Users/Sharif/AndroidStudioProjects/quran/assets/data/quran-uthmani.json');
  var data = file.readAsStringSync();
  var jsonData = jsonDecode(data);
  var quran = Quran.fromJson(jsonData);
  var groupBySurahs = groupBy(quran.data.surahs, (Surah surah) {
    return surah.ayahs;
  });
  var groupByJuz = groupBy(flatten(groupBySurahs.keys), (Ayah meh) {
    return meh.juz;
  });
  groupByJuz.forEach((key, value) {
    print("JUZ: $key");
    print(value.length);
  });
}

List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist];
