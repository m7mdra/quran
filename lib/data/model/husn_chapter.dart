
class HusnChapter {
  HusnChapter({
    this.list,
  });

  final List<Data> list;

  factory HusnChapter.fromJson(Map<String, dynamic> json) {
    var key = json.keys.first;
    return HusnChapter(
      list: json[key] == null
          ? null
          : List<Data>.from(json[key].map((x) => Data.fromJson(x))),
    );
  }
}

class Data {
  Data({
    this.id,
    this.arabicText,
    this.repeat,
  });

  final int id;
  final String arabicText;

  final int repeat;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["ID"] == null ? null : json["ID"],
        arabicText: json["ARABIC_TEXT"] == null ? null : json["ARABIC_TEXT"],
        repeat: json["REPEAT"] == null ? null : json["REPEAT"],
      );
}


