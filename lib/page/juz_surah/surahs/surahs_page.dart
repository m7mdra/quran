
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quran/data/local/model/surah.dart';
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
                 /*   Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TestWidget(
                                  surahList: state.surah,
                                  index: surah.number - 1,
                                )));*/
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

/*
class TestWidget extends StatefulWidget {
  final List<Surah> surahList;
  final int index;

  const TestWidget({Key key, this.surahList, this.index}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Map<int, List<Ayah>> surah;

  @override
  void initState() {
    var ayahs = flatten(widget.surahList.map((e) => e.ayahs).toList());
    surah = groupBy(ayahs, (e) {
      return e.page;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: IslamicAppBar(title: 'Hello',),
      body: PageView.builder(
        clipBehavior: Clip.antiAlias,
        onPageChanged: (page) {
          print(page);
        },
        controller: PageController(
            initialPage: page),
        itemBuilder: (context, index) {
          var list = surah.values.toList()[index];
          return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  */
/*SurahTitleWidget(
                    surah: widget.surah,
                  ),*//*

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
                        children: surah.values.toList()[index].map((e) {
                          return TextSpan(
                           */
/*   style: _playingAyahId == e.number ||
                                  widget.selectedAyahId == e.number
                                  ? TextStyle(
                                  backgroundColor:
                                  Theme.of(context).primaryColor.withAlpha(100))
                                  : null,*//*

                              text:
                              "${e.text.replaceFirst("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "")} ﴿${e.numberInSurah}﴾",
                              semanticsLabel: 'semanticsLabel',
                              recognizer: DoubleTapGestureRecognizer()
                                ..onDoubleTapDown = (tapDown) {
                                  */
/*showContextMenuAt(tapDown, context, e);*//*

                                });
                        }).toList()),
                    semanticsLabel: 'semanticsLabel',
                    textAlign: TextAlign.center,
                    softWrap: true,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ));
        },
        itemCount: surah.values.length,
      ),
    );
  }

  getTitle(index) {
    return widget.surahList[index].name;
  }
}
*/
