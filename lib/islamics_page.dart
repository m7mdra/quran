import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/page/dua_mathor/dua_mathor_page.dart';
import 'package:quran/page/husn_muslim/husn_muslim_page.dart';
import 'package:quran/page/khatm_quran/khatm_quran_page.dart';
import 'package:quran/page/morning_zekr/morning_zekr_page.dart';
import 'package:quran/page/musbaha/musbaha_page.dart';
import 'package:quran/page/night_zekr/night_zekr_page.dart';
import 'package:quran/page/post_prayer_zekr/post_prayer_zekr_page.dart';
import 'package:quran/page/qiblaa/qiblaa_page.dart';
import 'package:quran/page/riyadh/riyadh_book_page.dart';

import 'islamic_app_bar.dart';

class IslamicsPage extends StatefulWidget {
  @override
  _IslamicsPageState createState() => _IslamicsPageState();
}

class _IslamicsPageState extends State<IslamicsPage> {
  var islamicMenuList = <IslamicMenuItem>[
    IslamicMenuItem(
        'assets/images/azkar.svg', 'اذكار المساء', 'Evening Doaa'),
    IslamicMenuItem(
        'assets/images/azkar_mourning.svg', 'اذكار الصباح', 'Morning Doaa '),
    IslamicMenuItem(
        'assets/images/prayer_azkar.svg', 'اذكار الصلاة', 'Prayer Doaa '),
    IslamicMenuItem('assets/images/douaa.svg', 'أدعية مأثورة', ' Doaas'),
    IslamicMenuItem(
        'assets/images/husen.svg', 'حصن المسلم', "Muslims fortress"),
    IslamicMenuItem('assets/images/musbaha.svg', 'المسبحة', 'Tasbih'),
    IslamicMenuItem('assets/images/qibla.svg', 'اتجاه القبلة', 'Qiblah'),
    IslamicMenuItem('assets/images/doua_khtm.svg', 'دعاء ختم القران', 'End of quran Doaa'),
    IslamicMenuItem('assets/images/riyadh.svg', 'رياض الصالحين', 'Righteous Riad'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        context: context,
        title: 'اسلاميات',
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: islamicMenuList.length,
        itemBuilder: (BuildContext context, int index) {
          var data = islamicMenuList[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NightZekrPage()));
                }
                if (index == 1) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MorningZekrPage()));
                }
                if (index == 2) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostPrayerZekrPage()));
                }
                if (index == 3) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DuaMathorPage()));
                }
                if (index == 4) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HusnMuslimPage()));
                }
                if (index == 5) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MusbahaPage()));
                }
                if (index == 6) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => QiblaaPage()));
                }
                if (index == 7) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => KhatmQuranPage()));
                }
                if (index == 8) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RiyadhBookPage()));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(data.image),
                  Text(
                      Localizations.localeOf(context).languageCode == 'ar'
                          ? data.title
                          : data.titleEn,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class IslamicMenuItem {
  final String image;
  final String title;
  final String titleEn;

  IslamicMenuItem(this.image, this.title, this.titleEn);
}
