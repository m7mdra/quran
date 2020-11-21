import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quran/fake_data.dart';
import 'package:quran/main.dart';

class SuraPage extends StatefulWidget {
  @override
  _SuraPageState createState() => _SuraPageState();
}

class _SuraPageState extends State<SuraPage> with TickerProviderStateMixin {
  var sura = Sura.fromJson(jsonDecode(DATA));
  GlobalKey<ScaffoldState> _key = GlobalKey();
  var hideControls = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: hideControls
            ? PreferredSize(child: Container(), preferredSize: Size.zero)
            : IslamicAppBar(
                title: 'سورة البقرة',
                height: 56,
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {},
                  ),
                ],
              ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(
            sura.verses.map((e) => "${e.text} ﴿${e.number}﴾").join(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Al-QuranAlKareem',
              color: Color(0xff000000),
              fontSize: 23,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
        ));
  }
}

class Delegate extends FlowDelegate {
  @override
  void paintChildren(FlowPaintingContext context) {
    for (int i = 0; i < context.childCount; i++) {
      context.paintChild(i);
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    return true;
  }
}
/*itemBuilder: (context, index) {
            return Text(
                "${sura.verses[index].text} ﴿${sura.verses[index].number}﴾",
                style: TextStyle(

                  fontFamily: 'Al-QuranAlKareem',
                  color: Color(0xff000000),
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,

                ),textAlign: TextAlign.center,);
          },*/

class Sura {
  int number;
  String name;
  String transliterationEn;
  String translationEn;
  int totalVerses;
  String revelationType;
  List<Verses> verses;

  Sura(
      {this.number,
      this.name,
      this.transliterationEn,
      this.translationEn,
      this.totalVerses,
      this.revelationType,
      this.verses});

  Sura.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    transliterationEn = json['transliteration_en'];
    translationEn = json['translation_en'];
    totalVerses = json['total_verses'];
    revelationType = json['revelation_type'];
    if (json['verses'] != null) {
      verses = new List<Verses>();
      json['verses'].forEach((v) {
        verses.add(new Verses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['name'] = this.name;
    data['transliteration_en'] = this.transliterationEn;
    data['translation_en'] = this.translationEn;
    data['total_verses'] = this.totalVerses;
    data['revelation_type'] = this.revelationType;
    if (this.verses != null) {
      data['verses'] = this.verses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verses {
  int number;
  String text;
  String translationEn;
  String translationId;

  Verses({this.number, this.text, this.translationEn, this.translationId});

  Verses.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    text = json['text'];
    translationEn = json['translation_en'];
    translationId = json['translation_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['text'] = this.text;
    data['translation_en'] = this.translationEn;
    data['translation_id'] = this.translationId;
    return data;
  }
}
