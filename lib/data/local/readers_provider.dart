import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran/data/model/reader.dart';

class ReadersProvider {
  Future<List<Reader>> load() async {
    try {
      var jsonData =
          await rootBundle.loadString("assets/data/readers.json", cache: true);
      return Readers.fromJson(jsonDecode(jsonData)).list;
    } catch (error) {
      throw error;
    }
  }

  Future<Reader> defaultReader() async {
    try {
      var jsonData =
          await rootBundle.loadString("assets/data/readers.json", cache: true);
      var readers = Readers.fromJson(jsonDecode(jsonData));

      return readers.list
          .where((element) => element.identifier == "ar.alafasy")
          .first;
    } catch (error) {
      throw error;
    }
  }
}
