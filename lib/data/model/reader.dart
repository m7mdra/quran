class Readers {
  List<Data> data;

  Readers({
      this.data});

  Readers.fromJson(dynamic json) {
    if (json["data"] != null) {
      data = [];
      json["data"].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (data != null) {
      map["data"] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  String identifier;
  String language;
  String name;
  String englishName;
  String format;
  String type;
  dynamic direction;

  Data({
      this.identifier, 
      this.language, 
      this.name, 
      this.englishName, 
      this.format, 
      this.type, 
      this.direction});

  Data.fromJson(dynamic json) {
    identifier = json["identifier"];
    language = json["language"];
    name = json["name"];
    englishName = json["englishName"];
    format = json["format"];
    type = json["type"];
    direction = json["direction"];
  }

  Map<String, dynamic> toJson() {
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

}