import 'dart:math';

import 'package:flutter/foundation.dart';

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
  int id = Random().nextInt(10000000);
  DateTime dateTime = DateTime.now();
  double position;
  String name;

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
    name = map['name'];
    surah = map['surah'];
    position = map['position'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(map['date']);
  }
}
