import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/fake_data.dart';
import 'package:quran/main.dart';
import 'package:quran/popup_menu.dart';

class SuraPage extends StatefulWidget {
  @override
  _SuraPageState createState() => _SuraPageState();
}

class _SuraPageState extends State<SuraPage> with TickerProviderStateMixin {
  var sura = Sura.fromJson(jsonDecode(DATA));
  var hideControls = false;
  var expanded = false;
  PopupMenu menu = PopupMenu(backgroundColor: Colors.white);
 
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    return Scaffold(
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
              key: ObjectKey(1),
              children: sura.verses.map((e) {
                var _ayaKay = GlobalKey(debugLabel: 'keykey');
                print("﴿${e.number}﴾".length);
                return InkWell(
                  key: _ayaKay,
                  borderRadius: BorderRadius.circular(16),
                  onTap: (){
menu.show(
                        widgetKey: _ayaKay,
                        onAddCarClick: () {},
                        onAddRealStateClick: () {});
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

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext bc) {
          return SuraInfoModalSheet();
        });
  }
}

class SuraInfoModalSheet extends StatefulWidget {
  const SuraInfoModalSheet({
    Key key,
  }) : super(key: key);

  @override
  _SuraInfoModalSheetState createState() => _SuraInfoModalSheetState();
}

class _SuraInfoModalSheetState extends State<SuraInfoModalSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Stack(
          children: [
            Align(
              child: PlayButtonWidget(),
              alignment: AlignmentDirectional(0.0, -1.65),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("سُورة البَقَرةْ",
                          style: TextStyle(
                            fontFamily: 'alquran',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                      Text("بدء الإستماع",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          )),
                      Text("الجزْءُ الأَّوَلْ",
                          style: TextStyle(
                            fontFamily: 'alquran',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SuraOptions(
                        title: 'حفظ الصفحة',
                        image: 'assets/images/bookmark_sura.svg',
                      ),
                      SuraOptions(
                        title: 'التفسير الميسر',
                        image: 'assets/images/tafseer.svg',
                      ),
                      SuraOptions(
                        title: 'إختيار القارئ',
                        image: 'assets/images/choose_reader.svg',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      ),
    );
  }
}

class SuraOptions extends StatelessWidget {
  final String image;
  final String title;

  const SuraOptions({Key key, this.image, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(image),
        Text(title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ))
      ],
    );
  }
}

class PlayButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
              color: Color(0xff95B93E).withAlpha((255 / 0.16).round()),
              shape: BoxShape.circle),
        ),
        Container(
          width: 55,
          height: 55,
          child: IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {},
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: Color(0xff95B93E), shape: BoxShape.circle),
        ),
      ],
    );
  }
}

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
