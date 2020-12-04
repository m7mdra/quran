
class JuzResponse {
  int code;
  Juz juz;
  String status;

  JuzResponse({
      this.code, 
      this.juz, 
      this.status});

  JuzResponse.fromJson(dynamic json) {
    code = json["code"];
    juz = json["data"] != null ? Juz.fromJson(json["data"]) : null;
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
    if (juz != null) {
      map["data"] = juz.toJson();
    }
    map["status"] = status;
    return map;
  }

}
class SurahReference {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  String revelationType;
  int numberOfAyahs;

  SurahReference({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.revelationType,
    this.numberOfAyahs});

  SurahReference.fromJson(dynamic json) {
    number = json["number"];
    name = json["name"];
    englishName = json["englishName"];
    englishNameTranslation = json["englishNameTranslation"];
    revelationType = json["revelationType"];
    numberOfAyahs = json["numberOfAyahs"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["number"] = number;
    map["name"] = name;
    map["englishName"] = englishName;
    map["englishNameTranslation"] = englishNameTranslation;
    map["revelationType"] = revelationType;
    map["numberOfAyahs"] = numberOfAyahs;
    return map;
  }

}
class Ayah {
  int number;
  String text;
  int numberInSurah;
  int juz;
  int manzil;
  int page;
  int ruku;
  int hizbQuarter;

  Ayah({
    this.number,
    this.text,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter});

  Ayah.fromJson(dynamic json) {
    number = json["number"];
    text = json["text"];
    numberInSurah = json["numberInSurah"];
    juz = json["juz"];
    manzil = json["manzil"];
    page = json["page"];
    ruku = json["ruku"];
    hizbQuarter = json["hizbQuarter"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["number"] = number;
    map["text"] = text;

    map["numberInSurah"] = numberInSurah;
    map["juz"] = juz;
    map["manzil"] = manzil;
    map["page"] = page;
    map["ruku"] = ruku;
    map["hizbQuarter"] = hizbQuarter;
    return map;
  }

}
class Juz {
  int number;
  List<Ayah> ayahs;
  Map<String, SurahReference> surahs;
  Edition edition;

  Juz({this.number, this.ayahs, this.surahs, this.edition});

  Juz.fromJson(dynamic json) {
    number = json["number"];
    if (json["ayahs"] != null) {
      ayahs = [];
      json["ayahs"].forEach((v) {
        ayahs.add(Ayah.fromJson(v));
      });
    }
    surahs = (json['surahs'] as Map)
        .map((key, value) => MapEntry(key, SurahReference.fromJson(value)));
    edition =
    json["edition"] != null ? Edition.fromJson(json["edition"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["number"] = number;
    if (ayahs != null) {
      map["ayahs"] = ayahs.map((v) => v.toJson()).toList();
    }

    if (edition != null) {
      map["edition"] = edition.toJson();
    }
    return map;
  }
}
class Edition {
  String identifier;
  String language;
  String name;
  String englishName;
  String format;
  String type;
  String direction;

  Edition({
    this.identifier,
    this.language,
    this.name,
    this.englishName,
    this.format,
    this.type,
    this.direction});

  Edition.fromJson(dynamic json) {
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