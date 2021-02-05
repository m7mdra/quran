import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran/data/local/database_file.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/model/surah.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/di.dart';
import 'package:quran/islamic_app_bar.dart';
import 'package:quran/page/surah_details/bloc/reader/last_read_bloc.dart';

import 'bloc/bloc.dart';

class SurahsPage extends StatefulWidget {
  @override
  _SurahsPageState createState() => _SurahsPageState();
}

class _SurahsPageState extends State<SurahsPage>
    with AutomaticKeepAliveClientMixin {
  SurahsBloc _bloc;
  LastReadBloc _quranReaderBloc;

  @override
  void initState() {
    super.initState();
    _quranReaderBloc = context.bloc();
    _bloc = SurahsBloc(DependencyProvider.provide());
    _bloc.add(LoadSurahListEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder(
        cubit: _bloc,
        builder: (BuildContext context, state) {
          if (state is SurahsLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is SurahsLoadedSuccessState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                var surah = state.surah[index];

                return ListTile(
                  dense: true,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestWidget(

                                  page: surah.number - 1,
                                )));
                  },
                  leading: Text("﴿${surah.number}﴾",
                      style: TextStyle(
                        fontFamily: 'Al-QuranAlKareem',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      )),
                  title: Text(surah.name,
                      style: TextStyle(
                        fontFamily: 'alquran',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                  subtitle: Text("عدد الايات : ${surah.numberOfAyat} ",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff949393),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                      )),
                );
              },
              itemCount: state.surah.length,
            );
          }
          return Center(
              child: Text(AppLocalizations.of(context).failedToLoadData));
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class TestWidget extends StatefulWidget {

  final int page;

  const TestWidget({Key key, this.page}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  QuranDatabase quranDatabase = QuranDatabase(DatabaseFile());
  Map<int, List<Ayah>> ayatByPage = {};
  var _playingAyahId = 0;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    quranDatabase.ayat().then((value) {
      setState(() {
        ayatByPage = groupBy(value, (ayah) => ayah.pageId);
        pageController.jumpToPage(widget.page);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'Hello',
      ),
      body: PageView.builder(
        clipBehavior: Clip.antiAlias,
        onPageChanged: (page) {
          print(page);
        },
        controller: pageController,
        itemBuilder: (context, index) {
          var ayatList = ayatByPage.values.toList()[index];


          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(
                height: 16,
              ),
              Text.rich(
                TextSpan(
                    text: "",
                    semanticsLabel: 'semanticsLabel',
                    style: TextStyle(
                        fontFamily: 'alquran',
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                    children: ayatList.map((e) {
                      return TextSpan(
                          style: _playingAyahId == e.number
                              ? TextStyle(
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(100))
                              : null,
                          text:
                              "${e.text.replaceFirst("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "")} ﴿${e.numberInSurah}﴾",
                          semanticsLabel: 'semanticsLabel',
                          recognizer: DoubleTapGestureRecognizer()
                            ..onDoubleTapDown = (tapDown) {});
                    }).toList()),
                semanticsLabel: 'semanticsLabel',
                textAlign: TextAlign.justify,
                softWrap: true,
              ),
            ],
          ));
        },
        itemCount: ayatByPage.values.length,
      ),
    );
  }
}

class SurahTitleWidget extends StatelessWidget {
  final String surah;

  const SurahTitleWidget({Key key, this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset('assets/images/surah_name_title.svg'),
        Text(
          surah,
          style: TextStyle(
              color: Color(0xffFD9434),
              fontSize: 22,
              fontFamily: 'Al-QuranAlKareem'),
        )
      ],
    );
  }
}
