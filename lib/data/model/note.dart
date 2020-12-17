class Note {
  String title;
  String content;
  String id;
  DateTime dateTime;

  Note(this.title, this.content, this.id, this.dateTime);

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
