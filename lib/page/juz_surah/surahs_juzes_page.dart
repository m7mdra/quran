import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quran/di.dart';
import 'package:quran/page/juz_surah/surahs/surahs_page.dart';
import 'package:quran/page/surah_details/bloc/reader/last_read_bloc.dart';
import 'package:quran/page/surah_details/search_delegate.dart';
import 'package:quran/page/surah_details/surah_details.dart';

import '../../islamic_app_bar.dart';

class SurahsJuzesPage extends StatefulWidget {
  @override
  _SurahsJuzesPageState createState() => _SurahsJuzesPageState();
}

class _SurahsJuzesPageState extends State<SurahsJuzesPage>
    with TickerProviderStateMixin {
  LastReadBloc _quranReaderBloc;

  @override
  void initState() {
    super.initState();
    _quranReaderBloc = context.bloc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SurahsPage(),
      appBar: IslamicAppBar(
        context: context,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var result = await showSearch<AyahSearchResult>(
                  context: context,
                  delegate: AyahSearchDelegate(
                      SearchBloc(DependencyProvider.provide())));
              if (result != null) {
                _quranReaderBloc.add(SaveReadingSurah(
                    result.surah, result.surah.number - 1, 0.0));
                print(result.ayah);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SurahDetails(
                              surah: result.surah,
                              index: result.surah.number - 1,
                              highlightIndex: result.ayah.number,
                            )));
              }
            },
          ),
        ],
        title: AppLocalizations.of(context).suarAlquran,
      ),
    );
  }
}
