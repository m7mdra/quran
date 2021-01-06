import 'dart:math';

class NoteColumns {
  static String table = 'note';
  static String columnId = 'id';
  static String columnTitle = 'title';
  static String columnContent = 'content';
  static String columnDate = 'date';
  static var columns = [columnId, columnTitle, columnContent, columnDate];

  NoteColumns._();
}

class Note {
  String title;
  String content;
  int id = Random().nextInt(10000000);
  DateTime dateTime = DateTime.now();

  Note(this.title, this.content);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': dateTime.millisecondsSinceEpoch
    };
  }

  Note.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    content = map['content'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(map['date']);
  }
}
