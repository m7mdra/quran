import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:quran/data/model/quran.dart';

class BookmarkColumns {
  static String table = 'bookmark';
  static String columnId = 'id';
  static String columnName = 'name';
  static String columnPage = 'page';
  static String columnDate = 'date';
  static var columns = [
    columnId,
    columnName,
    columnPage,
    columnDate,
  ];

  BookmarkColumns._();
}

class Bookmark {
  int page;
  int id = Random().nextInt(10000000);
  DateTime dateTime = DateTime.now();
  
  String name;

 
  Bookmark(
      {@required this.page, @required this.name,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'page': page,
      'date': dateTime.millisecondsSinceEpoch
    };
  }

  Bookmark.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    page = map['page'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(map['date']);
  }
}
