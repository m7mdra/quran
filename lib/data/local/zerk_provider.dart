import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:quran/data/model/zekr.dart';

class ZekrProvider {
  Future<Zekr> night() {
    return _load("azkar_massa");
  }

  Future<Zekr> morning() {
    return _load("azkar_sabah");
  }

  Future<Zekr> postPrayer() {
    return _load("PostPrayer_azkar");
  }

  Future<Zekr> _load(String type) async {
    try {
      var data =
          await rootBundle.loadString("assets/data/$type.json", cache: true);
      return Zekr.fromJson(jsonDecode(data));
    } catch (error) {
      throw error;
    }
  }
}
