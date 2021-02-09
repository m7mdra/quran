import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this line
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/islamics_page.dart';
import 'package:quran/main/bloc/lang/language_cubit.dart';
import 'package:quran/main/bloc/theme/theme_cubit.dart';
import 'package:quran/page/about.dart';
import 'package:quran/page/juz_surah/surahs/surahs_page.dart';
import 'package:quran/page/juz_surah/surahs_juzes_page.dart';
import 'package:quran/page/notes_bookmarks/notes_bookmarks_page.dart';
import 'package:quran/page/surah_details/bloc/reader/last_read_bloc.dart';

import 'common.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LastReadBloc _lastReadBloc;

  @override
  void initState() {
    super.initState();
    _lastReadBloc = context.bloc<LastReadBloc>();
    _lastReadBloc.add(LoadLastReadingSurah());
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                child: BlocBuilder(
                  cubit: _lastReadBloc,
                  builder: (BuildContext context, state) {
                    if (state is LastReadLoaded) {
                      var lastRead = state.lastRead;
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TestWidget(
                                          page: lastRead.page-1,
                                        )));
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Text(AppLocalizations.of(context).lastReading,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  Text(lastRead.surah,
                                      style: TextStyle(
                                        fontFamily: 'Al-QuranAlKareem',
                                        fontSize: 20,
                                      )),
                                  Text("الصحفة ${lastRead.page}"),
                                  Text(AppLocalizations.of(context).tapToView,
                                      style: TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 12,
                                      )),
                                ],
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                              SvgPicture.asset(
                                  'assets/images/last_reading.svg'),
                            ],
                          ),
                        ),
                      );
                    } else
                      return Container();
                  },
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
                        if (index == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesBookMarksPage()));
                        }
                        if (index == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutPage()));
                        }
                        if (index == 3) {
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
            icon: SvgPicture.asset(isDarkMode(context)
                ? 'assets/images/ic_lang_dark.svg'
                : 'assets/images/ic_lang.svg'),
            onPressed: () {
              var langCubit = context.bloc<LanguageCubit>();
              if (Localizations.localeOf(context).languageCode == 'ar') {
                langCubit.en();
              } else {
                langCubit.ar();
              }
            },
            splashRadius: 20,
            iconSize: 40),
        IconButton(
            icon: SvgPicture.asset(isDarkMode(context)
                ? 'assets/images/ic_settings_dark.svg'
                : 'assets/images/ic_settings.svg'),
            onPressed: () {
              var themeCubit = context.bloc<ThemeCubit>();
              if (isDarkMode(context)) {
                themeCubit.light();
              } else {
                themeCubit.dark();
              }
            },
            splashRadius: 20,
            iconSize: 40),
/*        IconButton(
            icon: SvgPicture.asset(isDarkMode(context)
                ? 'assets/images/ic_reminder_dark.svg'
                : 'assets/images/ic_reminder.svg'),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReminderPage()));
            },
            splashRadius: 20,
            iconSize: 40),*/
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
                child: Text(
                    Localizations.localeOf(context).languageCode == 'ar'
                        ? item.title
                        : item.titleEn,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    )),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 16, end: 16, bottom: 16),
                child: Text(
                    Localizations.localeOf(context).languageCode == 'ar'
                        ? item.subtitle
                        : item.subtitleEn,
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
  final String titleEn;
  final String subtitle;
  final String subtitleEn;

  HomeMenuData(
      {this.image, this.title, this.titleEn, this.subtitle, this.subtitleEn});
}

final homeMenuDataList = [
  HomeMenuData(
      image: 'assets/images/quran.svg',
      title: 'السور ',
      titleEn: 'Surahs and Chapters',
      subtitleEn: 'With the voice of 17 of the most distinguished imams',
      subtitle: 'بصوت ١٧ قارئ من الائمة المتميزين'),
  HomeMenuData(
      image: 'assets/images/bookmarks.svg',
      title: 'العلامات و الملاحظات',
      titleEn: 'Bookmarks and notes',
      subtitleEn: 'Bookmarks on pages, notes',
      subtitle: 'العلامات علي الصفحات و الصور ، و الملاحظات المدونة'),
  HomeMenuData(
      image: 'assets/images/about.svg',
      title: 'عن الجهة المطوّرة',
      titleEn: 'About the developer',
      subtitleEn: '',
      subtitle: ''),
  HomeMenuData(
      image: 'assets/images/islamics.svg',
      title: 'إسلاميات',
      titleEn: 'Islamics',
      subtitleEn: 'Islamic prayers, dhikr and the Muslim fortress',
      subtitle: 'الأدعية ، الأذكار و حصن المسلم'),
];
