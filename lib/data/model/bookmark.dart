import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:quran/data/model/quran.dart';

class BookmarkColumns {
  static String table = 'bookmark';
  static String columnId = 'id';
  static String columnName = 'name';
  static String columnSurah = 'surah';
  static String columnDate = 'date';
  static String columnPosition = "position";
  static var columns = [
    columnId,
    columnName,
    columnSurah,
    columnDate,
    columnPosition
  ];

  BookmarkColumns._();
}

class Bookmark {
  int surah;
  Surah _surah;
  int id = Random().nextInt(10000000);
  DateTime dateTime = DateTime.now();
  double position;
  String name;

  set setSurah(Surah value) {
    _surah = value;
  }


  Surah get getSurah => _surah;

  Bookmark(
      {@required this.surah, @required this.name, @required this.position});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surah': surah,
      'position': position,
      'date': dateTime.millisecondsSinceEpoch
    };
  }

  Bookmark.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    surah = null;
    name = map['name'];
    surah = map['surah'];
    position = map['position'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(map['date']);
  }
}
