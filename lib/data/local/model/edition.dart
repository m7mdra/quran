/// identifier : "ar.muyassar"
/// language : "ar"
/// name : "تفسير المیسر"
/// englishName : "King Fahad Quran Complex"
/// format : "text"
/// type : "tafsir"
/// direction : "rtl"

class Edition {
  String identifier;
  String language;
  String name;
  String englishName;
  String format;
  String type;
  String direction;

  Edition(
      {this.identifier,
      this.language,
      this.name,
      this.englishName,
      this.format,
      this.type,
      this.direction});

  Edition.fromMap(dynamic json) {
    identifier = json["identifier"];
    language = json["language"];
    name = json["name"];
    englishName = json["englishName"];
    format = json["format"];
    type = json["type"];
    direction = json["direction"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["identifier"] = identifier;
    map["language"] = language;
    map["name"] = name;
    map["englishName"] = englishName;
    map["format"] = format;
    map["type"] = type;
    map["direction"] = direction;
    return map;
  }

  @override
  String toString() {
    return '$identifier:$type';
  }
}
