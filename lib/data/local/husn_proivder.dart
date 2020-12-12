import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran/data/model/husn.dart';

class HusnProvider {
  Future<List<Chapter>> load() async {
    try {
      var jsonData = await rootBundle
          .loadString("assets/data/husn/husn_data.json", cache: true);
      return Chapters.fromJson(jsonDecode(jsonData)).data
        ..sort((first, second) => first.id.compareTo(second.id));
    } catch (error) {
      throw error;
    }
  }
}
