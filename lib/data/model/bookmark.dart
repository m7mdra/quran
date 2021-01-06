import 'dart:math';

class BookmarkColumns {
  static String table = 'bookmark';
  static String columnId = 'id';
  static String columnName = 'name';
  static String columnSurah = 'surah';
  static String columnDate = 'date';
  static var columns = [columnId, columnName, columnSurah, columnDate];

  BookmarkColumns._();
}

class Bookmark {
  int surah;
  int id = Random().nextInt(10000000);
  DateTime dateTime = DateTime.now();
  String name;


  Bookmark({this.surah, this.name});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'surah': surah,
      'date': dateTime.millisecondsSinceEpoch
    };
  }

  Bookmark.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    surah = map['surah'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(map['date']);
  }
}
