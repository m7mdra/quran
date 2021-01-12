import 'package:flutter/material.dart';
import 'package:quran/generated/l10n.dart';
import 'package:quran/main.dart';
import 'package:quran/page/juz_surah/surahs/surahs_page.dart';

import '../../islamic_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SurahsJuzesPage extends StatefulWidget {
  @override
  _SurahsJuzesPageState createState() => _SurahsJuzesPageState();
}

class _SurahsJuzesPageState extends State<SurahsJuzesPage>
    with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SurahsPage(),
      appBar: IslamicAppBar(
        context: context,
        title: AppLocalizations.of(context).suarAlquran,
      ),
    );
  }
}
