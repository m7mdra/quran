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
var expanded = false;
var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: hideControls
          ? PreferredSize(child: Container(), preferredSize: Size.zero)
          : IslamicAppBar(
              context: context,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: sura.verses.map((e) {
                print("﴿${e.number}﴾".length);
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    displayModalBottomSheet(context);
                  },
                  child: Text.rich(
                    TextSpan(
                        text: "${e.text}".trim(),
                        style: TextStyle(
                            fontFamily: 'alquran',
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                              text: ' ﴿${e.number}﴾',
                              style: TextStyle(
                                fontFamily: "Al-QuranAlKareem",
                                fontSize: 18,
                              ))
                        ]),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontStyle: FontStyle.normal,
                    ),
                    softWrap: true,
                    textDirection: TextDirection.rtl,
                  ),
                );
              }).toList(),
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              textDirection: TextDirection.rtl,
              runAlignment: WrapAlignment.center,
              runSpacing: 0,
              spacing: 0,
            ),
          ),

        ],
      ),
    );
  }

  void displayPersistentBottomSheet() {
    _scaffoldKey.currentState.showBottomSheet<void>((BuildContext context) {
      return Container(

        child: Card(
          color: Color(0xffffffff),
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))),
          child: Text(
            'This is a persistent bottom sheet. Drag downwards to dismiss it.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
      );
    });
  }
  void displayModalBottomSheet(context) {
    showModalBottomSheet(
      barrierColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext bc) {
          return Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))),

          );
        });
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
