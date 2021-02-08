class LastRead {
  final String surah;
  int page;
  final double position;
  static LastRead kDefault =
      LastRead(page: 0, position: 0, surah: 'سورة الفاتحة');

  LastRead({this.surah, this.page, this.position});

  Map<String, dynamic> toJson() {
    return {'surah': surah, 'page': page, 'position': position};
  }

  factory LastRead.fromJson(Map<String, dynamic> map) {
    return LastRead(
        surah: map['surah'], position: map['position'], page: map['page']);
  }
}
