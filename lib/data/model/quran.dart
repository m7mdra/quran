class Quran {
  Quran({
    this.data,
  });

  Data data;

  factory Quran.fromJson(Map<String, dynamic> json) =>
      Quran(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "data": data.toJson(),
      };
}
class Juz {
  int number;
  List<Ayah> ayahs;
  Map<String, Surah> surahs;

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
        .map((key, value) => MapEntry(key, Surah.fromJson(value)));
  }

}
class Data {
  Data({
    this.surahs,
  });

  List<Surah> surahs;

  factory Data.fromJson(Map<String, dynamic> json) =>
      Data(
        surahs: List<Surah>.from(json["surahs"].map((x) => Surah.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "surahs": List<dynamic>.from(surahs.map((x) => x.toJson())),
      };
}

class Surah {
  Surah({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.revelationType,
    this.ayahs,
  });

  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  String revelationType;
  List<Ayah> ayahs;

  factory Surah.fromJson(Map<String, dynamic> json) =>
      Surah(
        number: json["number"],
        name: json["name"],
        englishName: json["englishName"],
        englishNameTranslation: json["englishNameTranslation"],
        revelationType: json["revelationType"],
        ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationType,
        "ayahs": List<dynamic>.from(ayahs.map((x) => x.toJson())),
      };
  @override
  String toString() {
    return "$name";
  }
}

class Ayah {
  Ayah({
    this.number,
    this.text,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter,
  });

  int number;
  String text;
  int numberInSurah;
  int juz;
  int manzil;
  int page;
  int ruku;
  int hizbQuarter;

  factory Ayah.fromJson(Map<String, dynamic> json) =>
      Ayah(
        number: json["number"],
        text: json["text"],
        numberInSurah: json["numberInSurah"],
        juz: json["juz"],
        manzil: json["manzil"],
        page: json["page"],
        ruku: json["ruku"],
        hizbQuarter: json["hizbQuarter"],
      );

  Map<String, dynamic> toJson() =>
      {
        "number": number,
        "text": text,
        "numberInSurah": numberInSurah,
        "juz": juz,
        "manzil": manzil,
        "page": page,
        "ruku": ruku,
        "hizbQuarter": hizbQuarter,
      };
  @override
  String toString() {
    // TODO: implement toString
    return "$number $text";
  }
}
