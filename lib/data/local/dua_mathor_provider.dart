import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran/data/model/dua_mathor.dart';

class DuaMathorProvider {
  Future<List<DuaMathor>> load() async {
    try {
      var data =
          await rootBundle.loadString("assets/data/mathura.json", cache: true);
      return (jsonDecode(data) as List)
          .map((e) => DuaMathor.fromJson(e))
          .toList();
    } catch (error) {
      throw error;
    }
  }
}
