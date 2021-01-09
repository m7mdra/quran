import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/islamics_page.dart';
import 'package:quran/main/bloc/theme/theme_cubit.dart';
import 'package:quran/page/juz_surah/surahs_juzes_page.dart';
import 'package:quran/page/notes_bookmarks/notes_bookmarks_page.dart';
import 'package:quran/page/reminder_page.dart';
import 'package:quran/page/surah_details/bloc/reader/quran_reader_bloc.dart';
import 'package:quran/page/surah_details/quran_reader_page.dart';

import 'common.dart';
import 'page/juz_surah/surahs/bloc/bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QuranReaderBloc _quranReaderBloc;

  SurahsBloc _surahsBloc;

  @override
  void initState() {
    super.initState();
    _quranReaderBloc = context.bloc<QuranReaderBloc>();
    _surahsBloc = context.bloc<SurahsBloc>();
    _quranReaderBloc.add(LoadLastReadingSurah());
  }

  @override
  void dispose() {
    _surahsBloc.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
          listener: (BuildContext context, state) {
            if (state is SurahsLoadingState) {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                        content: CircularProgressIndicator(),
                      ));
            }
            if (state is SurahsLoadedSuccessState) {
              Navigator.of(context, rootNavigator: true).pop("dialog");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuranReaderPage(
                            index: state.index,
                            surahs: state.surah,
                          )));
            }
            if (state is SurahsErrorState) {
              Navigator.of(context, rootNavigator: true).pop("dialog");
            }
          },
          cubit: _surahsBloc,
          child: buildBody(context)),
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
                  cubit: _quranReaderBloc,
                  builder: (BuildContext context, state) {
                    if (state is QuranReaderLoaded) {
                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: InkWell(
                          onTap: () {
                            _surahsBloc
                                .add(LoadSurahListIndexed(state.position));
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Text("أخر قراءة",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  Text(state.surah.name,
                                      style: TextStyle(
                                        fontFamily: 'Al-QuranAlKareem',
                                        fontSize: 20,
                                      )),
                                  Text("اضغط للذهاب للسورة",
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
              //TODO: change language
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
        IconButton(
            icon: SvgPicture.asset(isDarkMode(context)
                ? 'assets/images/ic_reminder_dark.svg'
                : 'assets/images/ic_reminder.svg'),
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ReminderPage()));
            },
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
