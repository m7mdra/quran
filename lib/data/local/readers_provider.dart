import 'dart:convert';

import 'package:quran/data/model/reader.dart';
import 'package:flutter/services.dart';

class ReadersProvider {
  Future<Readers> load() async {
    var jsonData =
        await rootBundle.loadString("assets/data/readers.json", cache: true);
    return Readers.fromJson(jsonDecode(jsonData));
  }
}
