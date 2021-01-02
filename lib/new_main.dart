import 'dart:convert';
import 'dart:io';

import 'data/model/quran.dart';
var string = """
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
void main() {
print(Surah.fromJson(jsonDecode(string)));
}

