import 'juz_response.dart';

class SurahResponse {
  int code;
  String status;
  Surah surah;

  SurahResponse({this.code, this.status, this.surah});

  SurahResponse.fromJson(dynamic json) {
    code = json["code"];
    status = json["status"];
    surah = json["data"] != null ? Surah.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
    map["status"] = status;
    if (surah != null) {
      map["data"] = surah.toJson();
    }
    return map;
  }
}

class Surah {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  String revelationType;
  int numberOfAyahs;
  List<Ayah> ayahs;
  Edition edition;

  Surah(
      {this.number,
      this.name,
      this.englishName,
      this.englishNameTranslation,
      this.revelationType,
      this.numberOfAyahs,
      this.ayahs,
      this.edition});

  Surah.fromJson(dynamic json) {
    number = json["number"];
    name = json["name"];
    englishName = json["englishName"];
    englishNameTranslation = json["englishNameTranslation"];
    revelationType = json["revelationType"];
    numberOfAyahs = json["numberOfAyahs"];
    if (json["ayahs"] != null) {
      ayahs = [];
      json["ayahs"].forEach((v) {
        ayahs.add(Ayah.fromJson(v));
      });
    }
    edition =
        json["edition"] != null ? Edition.fromJson(json["edition"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["number"] = number;
    map["name"] = name;
    map["englishName"] = englishName;
    map["englishNameTranslation"] = englishNameTranslation;
    map["revelationType"] = revelationType;
    map["numberOfAyahs"] = numberOfAyahs;
    if (ayahs != null) {
      map["ayahs"] = ayahs.map((v) => v.toJson()).toList();
    }
    if (edition != null) {
      map["edition"] = edition.toJson();
    }
    return map;
  }
}
