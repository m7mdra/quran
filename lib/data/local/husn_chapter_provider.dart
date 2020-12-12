import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran/data/model/husn_chapter.dart';

class HusnChapterProvider {
  Future<HusnChapter> load(int id) async {
    try {
      var jsonData = await rootBundle
          .loadString("assets/data/husn/chapters/$id.json", cache: true);
      return HusnChapter.fromJson(jsonDecode(jsonData));
    } catch (error) {
      throw error;
    }
  }
}
