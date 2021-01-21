import 'dart:convert';

class Quran {
  Quran({
    this.data,
  });

  Data data;

  factory Quran.fromJson(Map<String, dynamic> json) => Quran(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Juz {
  int number;
  List<Ayah> ayahs;
  List<Surah> surahs;

  Juz({this.number, this.ayahs, this.surahs});

  @override
  String toString() {
    return "Juz $number: ${surahs.map((e) => e.name)}";
  }
}

class Data {
  Data({
    this.surahs,
  });

  List<Surah> surahs;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        surahs: List<Surah>.from(json["surahs"].map((x) => Surah.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
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

  static Surah kTheOpening = Surah.fromJson(jsonDecode(openingJson));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Surah &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;
  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  String revelationType;
  List<Ayah> ayahs;

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json["number"],
        name: json["name"],
        englishName: json["englishName"],
        englishNameTranslation: json["englishNameTranslation"],
        revelationType: json["revelationType"],
        ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationType,
        "ayahs": List<dynamic>.from(ayahs.map((x) => x.toJson())),
      };

  @override
  String toString() {
    return "$name\n";
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Ayah &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;

  int number;
  String text;
  int numberInSurah;
  int juz;
  int manzil;
  int page;
  int ruku;
  int hizbQuarter;

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        number: json["number"],
        text: json["text"],
        numberInSurah: json["numberInSurah"],
        juz: json["juz"],
        manzil: json["manzil"],
        page: json["page"],
        ruku: json["ruku"],
        hizbQuarter: json["hizbQuarter"],
      );

  Map<String, dynamic> toJson() => {
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
    return "$number $text\n";
  }
}

const openingJson = """
{
        "number": 1,
        "name": "سُورَةُ ٱلْفَاتِحَةِ",
        "englishName": "Al-Faatiha",
        "englishNameTranslation": "The Opening",
        "revelationType": "Meccan",
        "ayahs": [
          {
            "number": 1,
            "text": "﻿بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
            "numberInSurah": 1,
            "juz": 1,
            "manzil": 1,
            "page": 1,
            "ruku": 1,
            "hizbQuarter": 1,
            "sajda": false
          },
          {
            "number": 2,
            "text": "ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ",
            "numberInSurah": 2,
            "juz": 1,
            "manzil": 1,
            "page": 1,
            "ruku": 1,
            "hizbQuarter": 1,
            "sajda": false
          },
          {
            "number": 3,
            "text": "ٱلرَّحْمَٰنِ ٱلرَّحِيمِ",
            "numberInSurah": 3,
            "juz": 1,
            "manzil": 1,
            "page": 1,
            "ruku": 1,
            "hizbQuarter": 1,
            "sajda": false
          },
          {
            "number": 4,
            "text": "مَٰلِكِ يَوْمِ ٱلدِّينِ",
            "numberInSurah": 4,
            "juz": 1,
            "manzil": 1,
            "page": 1,
            "ruku": 1,
            "hizbQuarter": 1,
            "sajda": false
          },
          {
            "number": 5,
            "text": "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
            "numberInSurah": 5,
            "juz": 1,
            "manzil": 1,
            "page": 1,
            "ruku": 1,
            "hizbQuarter": 1,
            "sajda": false
          },
          {
            "number": 6,
            "text": "ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ",
            "numberInSurah": 6,
            "juz": 1,
            "manzil": 1,
            "page": 1,
            "ruku": 1,
            "hizbQuarter": 1,
            "sajda": false
          },
          {
            "number": 7,
            "text": "صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ",
            "numberInSurah": 7,
            "juz": 1,
            "manzil": 1,
            "page": 1,
            "ruku": 1,
            "hizbQuarter": 1,
            "sajda": false
          }
        ]
      }
""";
