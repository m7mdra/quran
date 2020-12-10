import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/main.dart';
import 'package:quran/page/morning_zekr/morning_zekr_page.dart';
import 'package:quran/page/night_zekr/night_zekr_page.dart';
import 'package:quran/page/post_prayer_zekr/post_prayer_zekr_page.dart';

class IslamicsPage extends StatefulWidget {
  @override
  _IslamicsPageState createState() => _IslamicsPageState();
}

class _IslamicsPageState extends State<IslamicsPage> {
  var islamicMenuList = <IslamicMenuItem>[
    IslamicMenuItem('assets/images/azkar.svg', 'اذكار المساء'),
    IslamicMenuItem('assets/images/azkar_mourning.svg', 'اذكار الصباح'),
    IslamicMenuItem('assets/images/prayer_azkar.svg', 'اذكار الصلاة'),
    IslamicMenuItem('assets/images/douaa.svg', 'أدعية مأثورة'),
    IslamicMenuItem('assets/images/husen.svg', 'حصن المسلم'),
    IslamicMenuItem('assets/images/musbaha.svg', 'المسبحة'),
    IslamicMenuItem('assets/images/qibla.svg', 'اتجاه القبلة'),
    IslamicMenuItem('assets/images/doua_khtm.svg', 'دعاء ختم القران'),
    IslamicMenuItem('assets/images/riyadh.svg', 'رياض الصالحين'),
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
                if(index==1){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MorningZekrPage()));
                }
                if(index==2){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PostPrayerZekrPage()));
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(data.image),
                  Text(data.title,
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

  IslamicMenuItem(this.image, this.title);
}
