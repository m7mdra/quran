class Readers {
  List<Reader> list;

  Readers({this.list});

  Readers.fromJson(dynamic json) {
    if (json["data"] != null) {
      list = [];
      json["data"].forEach((v) {
        list.add(Reader.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (list != null) {
      map["data"] = list.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Reader {
  String identifier;
  String language;
  String name;
  String englishName;
  String format;
  String type;
  bool isSelect = false;

  bool isSelected(String id) => id == identifier;

  Reader(
      {this.identifier,
      this.language,
      this.name,
      this.englishName,
      this.format,
      this.type});

  Reader.fromJson(dynamic json) {
    identifier = json["identifier"];
    language = json["language"];
    name = json["name"];
    englishName = json["englishName"];
    format = json["format"];
    type = json["type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["identifier"] = identifier;
    map["language"] = language;
    map["name"] = name;
    map["englishName"] = englishName;
    map["format"] = format;
    map["type"] = type;
    return map;
  }
}
