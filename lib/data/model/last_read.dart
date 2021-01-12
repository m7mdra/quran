import 'dart:convert';

import 'package:quran/data/model/quran.dart';

class LastRead {
  final Surah surah;
  final int index;
  final double position;
  static LastRead kDefault = LastRead(
      index: 0, position: 0, surah: Surah.kTheOpening);

  LastRead({this.surah, this.index, this.position});

  Map<String, dynamic> toJson() {
    return {'surah': surah.toJson(), 'index': index, 'position': position};
  }

  factory LastRead.fromJson(Map<String, dynamic> map) {
    return LastRead(
        surah: Surah.fromJson(map['surah']),
        position: map['position'],
        index: map['index']);
  }
}
