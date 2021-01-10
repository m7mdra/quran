class ReminderColumns {
  static String table = 'reminder';
  static String columnId = 'id';
  static String columnName = 'name';
  static String columnCompleted = 'completed';
  static String columnDate = 'date';
  static var columns = [columnId, columnName, columnCompleted, columnDate];

  ReminderColumns._();
}

class Reminder {
  int id;

  int _completed = 0;
  String name;
  DateTime dateTime = DateTime.now();

  Reminder(this.id, this.name);

  bool get isCompleted => _completed == 1;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'completed': _completed,
      'date': dateTime.millisecondsSinceEpoch,
      'id': id
    };
  }

  Reminder.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    _completed = map['completed'];
    name = map['name'];
    dateTime = DateTime.fromMillisecondsSinceEpoch(map['date']);
  }
}
