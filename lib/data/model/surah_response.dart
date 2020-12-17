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


}

class Surah {
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  String revelationType;
  int numberOfAyahs;
  List<Ayah> ayahs;

  Surah(
      {this.number,
      this.name,
      this.englishName,
      this.englishNameTranslation,
      this.revelationType,
      this.numberOfAyahs,
      this.ayahs});

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
  }


}
