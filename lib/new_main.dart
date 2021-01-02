import 'dart:convert';
import 'dart:io';

import 'data/model/quran.dart';

void main() {
  var file = File(
      "/Users/Sharif/AndroidStudioProjects/quran/assets/data/quran-uthmani.json");
  var data = file.readAsStringSync();
  var json = jsonDecode(data);
  var quran = Quran.fromJson(json);
  var surahs = quran.data.surahs;
  var ayah = surahs.map((e) => e.ayahs).toList();
  print(ayah);
}

List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist].toList();
