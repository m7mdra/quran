import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';

import 'package:quran/di.dart';
import 'package:quran/page/quran_reader/bloc/reader/last_read_bloc.dart';
import 'package:quran/page/quran_reader/quran_reader_page.dart';

import '../../../widget/popup_menu.dart';
import 'bloc/bloc.dart';

class SurahsPage extends StatefulWidget {
  @override
  _SurahsPageState createState() => _SurahsPageState();
}

class _SurahsPageState extends State<SurahsPage>
    with AutomaticKeepAliveClientMixin {
  SurahsBloc _bloc;
  LastReadBloc _lastReadBloc;

  @override
  void initState() {
    super.initState();
    _lastReadBloc = context.bloc();
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
                    _lastReadBloc
                        .add(SaveReadingSurah(surah.name, surah.page, 0));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuranReaderPage(
                                  page: surah.page - 1,
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
