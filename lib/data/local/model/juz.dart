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
  int page;



  JuzReference(
      {this.suratId,
      this.juzId,
      this.id,
      this.text,
      this.page,
      this.numberInSurat,
      this.surahName});

  JuzReference.fromMap(dynamic map) {
    suratId = map["surat_id"];
    juzId = map["juz_id"];
    id = map["id"];
    text = map["text"];
    surahName = map["name"];
    numberInSurat = map["numberinsurat"];
    page = map["page_id"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["surat_id"] = suratId;
    map["juz_id"] = juzId;
    map["id"] = id;
    map["text"] = text;
    map["numberinsurat"] = numberInSurat;
    map["name"] = surahName;
    map["page_id"] = page;

    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
