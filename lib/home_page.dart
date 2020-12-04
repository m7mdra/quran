import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/islamics_page.dart';
import 'package:quran/notes_bookmarks_page.dart';

import 'common.dart';
import 'juz_surah/surahs_juzes_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(context),
      appBar: buildAppBar(),
    );
  }

  Stack buildBody(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/main_background.png',
          fit: BoxFit.fitWidth,
        ),
        Align(
          alignment: Directionality.of(context) == TextDirection.rtl
              ? AlignmentDirectional.bottomEnd
              : AlignmentDirectional.bottomStart,
          child: Image.asset(
            'assets/images/left_bubble.png',
            width: MediaQuery.of(context).size.width * 0.25,
          ),
        ),
        Align(
          alignment: Directionality.of(context) == TextDirection.rtl
              ? AlignmentDirectional.bottomStart
              : AlignmentDirectional.bottomEnd,
          child: Image.asset(
            'assets/images/right_bubble.png',
            width: MediaQuery.of(context).size.width * 0.28,
          ),
        ),
        Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.35,
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Text("أخر صفحة",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              )),
                          Text("الجزء الثاني - صفحة رقم 112",
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 12,
                              )),
                          Text("اَل عِمران",
                              style: TextStyle(
                                fontFamily: 'Al-QuranAlKareem',
                                fontSize: 20,
                              ))
                        ],
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                      SvgPicture.asset('assets/images/last_reading.svg'),
                    ],
                  ),
                ),
              ),
              StaggeredGridView.countBuilder(
                  primary: false,
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  shrinkWrap: true,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: homeMenuDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var item = homeMenuDataList[index];
                    return HomeMenuItem(
                      item: item,
                      onTap: () {
                        print(index);
                        if (index == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SurahsJuzesPage()));
                        }
                        if(index ==1){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesBookMarksPage()));
                        }
                        if(index==3){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IslamicsPage()));
                        }
                      },
                    );
                  },
                  crossAxisCount: 2,
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(1))
            ],
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
          icon: SvgPicture.asset(isDarkMode(context)?'assets/images/ic_menu_dark.svg':'assets/images/ic_menu.svg'),
          onPressed: () {},
          splashRadius: 20,
          iconSize: 40),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
            icon: SvgPicture.asset(isDarkMode(context)
                ? 'assets/images/ic_lang_dark.svg'
                : 'assets/images/ic_lang.svg'),
            onPressed: () {},
            splashRadius: 20,
            iconSize: 40),
        IconButton(
            icon: SvgPicture.asset(isDarkMode(context)
                ? 'assets/images/ic_settings_dark.svg'
                : 'assets/images/ic_settings.svg'),
            onPressed: () {},
            splashRadius: 20,
            iconSize: 40),
        IconButton(
            icon: SvgPicture.asset(isDarkMode(context)
                ? 'assets/images/ic_reminder_dark.svg'
                : 'assets/images/ic_reminder.svg'),
            onPressed: () {},
            splashRadius: 20,
            iconSize: 40),
      ],
    );
  }

}


class HomeMenuItem extends StatelessWidget {
  final VoidCallback onTap;

  const HomeMenuItem({
    Key key,
    @required this.item,
    this.onTap,
  }) : super(key: key);

  final HomeMenuData item;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: SvgPicture.asset(
                  item.image,
                  fit: BoxFit.none,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 8, end: 8),
                child: Text(item.title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
                child: Text(item.subtitle,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                    )),
              )
            ],
          ),
        ));
  }
}

class HomeMenuData {
  final String image;
  final String title;
  final String subtitle;

  HomeMenuData({this.image, this.title, this.subtitle});
}

final homeMenuDataList = [
  HomeMenuData(
      image: 'assets/images/quran.svg',
      title: 'سور و أجزاءالقران ',
      subtitle: 'بصوت 22 قارئ من أئمة الحرمين'),
  HomeMenuData(
      image: 'assets/images/bookmarks.svg',
      title: 'العلامات و الملاحظات',
      subtitle: 'العلامات علي الصفحات و السور ، و الملاحظات المدونة'),
  HomeMenuData(
      image: 'assets/images/about.svg',
      title: 'عن الجهة المطوّرة',
      subtitle: ''),
  HomeMenuData(
      image: 'assets/images/islamics.svg',
      title: 'إسلاميات',
      subtitle: 'يحتوي علي الأدعية ، الأذكار و حصن المسلم '),
];
