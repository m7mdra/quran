class JuzResponse {
  int code;
  Juz juz;
  String status;

  JuzResponse({this.code, this.juz, this.status});

  JuzResponse.fromJson(dynamic json) {
    code = json["code"];
    juz = json["data"] != null ? Juz.fromJson(json["data"]) : null;
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = code;
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

  SurahReference(
      {this.number,
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
  int page;
  SurahReference surahReference;

  Ayah({
    this.number,
    this.text,
    this.numberInSurah,
    this.juz,
    this.surahReference,
    this.page,
  });

  Ayah.fromJson(dynamic json) {
    number = json["number"];
    text = json["text"];
    numberInSurah = json["numberInSurah"];
    juz = json["juz"];
    if (json['surah'] != null)
      surahReference = SurahReference.fromJson(json['surah']);
    page = json["page"];
  }
}

class Juz {
  int number;
  List<Ayah> ayahs;
  Map<String, SurahReference> surahs;

  Juz({this.number, this.ayahs, this.surahs});

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
  }
}
