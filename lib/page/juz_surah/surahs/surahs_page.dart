import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/di.dart';
import 'package:quran/islamic_app_bar.dart';
import 'package:quran/page/surah_details/bloc/reader/last_read_bloc.dart';
import 'package:quran/page/surah_details/bloc/readers/readers_bloc.dart';
import 'package:quran/page/surah_details/surah_player.dart';
import 'package:quran/page/surah_details/surah_widget.dart';

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
                                  surahList: state.surah,
                                  index: surah.number - 1,
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
                  subtitle: Text("عدد الايات : ${surah.ayahs.length} ",
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
  final List<Surah> surahList;
  final int index;

  const TestWidget({Key key, this.surahList, this.index}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  Surah surah;

  @override
  void initState() {
    surah = widget.surahList[widget.index];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: surah.name,
      ),
      body: PageView.builder(
        clipBehavior: Clip.antiAlias,
        onPageChanged: (page) {
          setState(() {
            surah = widget.surahList[page];
          });
        },
        controller: PageController(initialPage: widget.index),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var value = widget.surahList[index];
          return SurahWidget(
            surah: value,
            player: SurahPlayer(
                ReadersBloc(
                    DependencyProvider.provide(), DependencyProvider.provide()),
                DependencyProvider.provide()),
          );
        },
        itemCount: widget.surahList.length,
      ),
    );
  }

  getTitle(index) {
    return widget.surahList[index].name;
  }
}
