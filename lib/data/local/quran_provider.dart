import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:quran/data/model/quran.dart';

class QuranProvider {
  Future<Quran> load() async {
    var data = await rootBundle.loadString("assets/data/quran-uthmani.json",
        cache: true);

    var jsonData = jsonDecode(data);
    return Quran.fromJson(jsonData);
  }

  Future<List<Surah>> loadSurahList() async {
    var quran = await load();
    return quran.data.surahs;
  }

  Future<List<Juz>> loadJuzList() async {
    var quran = await load();
    List<Juz> juzList = [];
    for (var index = 1; index <= 30; index++) {
      var surah = quran.data.surahs.where((element) {
        return element.ayahs.any((element) => element.juz == index);
      });

      var juz = Juz(
          number: index,
          ayahs: flatten(surah.map((e) => e.ayahs).toList()),
          surahs: surah.toList());
      juzList.add(juz);
    }
    return juzList;
  }
}

List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist].toList();
