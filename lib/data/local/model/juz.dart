/// surat_id : 3
/// juz_id : 4
/// id : 480558
/// numberinsurat : 93

class JuzReference {
  int suratId;
  int juzId;
  int id;
  int numberInSurat;
  String text;
  String surahName;

  JuzReference(
      {this.suratId,
      this.juzId,
      this.id,
      this.text,
      this.numberInSurat,
      this.surahName});

  JuzReference.fromMap(dynamic map) {
    suratId = map["surat_id"];
    juzId = map["juz_id"];
    id = map["id"];
    text = map["text"];
    surahName = map["name"];
    numberInSurat = map["numberinsurat"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["surat_id"] = suratId;
    map["juz_id"] = juzId;
    map["id"] = id;
    map["text"] = text;
    map["numberinsurat"] = numberInSurat;
    map["name"] = surahName;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
