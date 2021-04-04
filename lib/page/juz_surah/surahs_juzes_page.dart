import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quran/page/juz_surah/hizb_quarter/hizb_quarter_page.dart';
import 'package:quran/page/juz_surah/surahs/surahs_page.dart';

import '../../widget/islamic_app_bar.dart';
import 'juzes/juz_page.dart';

class SurahsJuzesPage extends StatefulWidget {
  @override
  _SurahsJuzesPageState createState() => _SurahsJuzesPageState();
}

class _SurahsJuzesPageState extends State<SurahsJuzesPage>
    with TickerProviderStateMixin {
  PageController _pageController;
  TabController _tabController;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          _tabController.animateTo(index,
              duration: Duration(milliseconds: 200), curve: Curves.linear);
        },
        children: [SurahsPage(), JuzPage(), HizbQuarterPage()],
      ),
      appBar: IslamicAppBar(
        context: context,
        title: AppLocalizations.of(context).suarAlquran,
        bottom: TabBar(
          onTap: (index) {
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 300), curve: Curves.linear);
          },
          indicatorWeight: 5,
          labelColor: Colors.white,
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xffffffff),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          labelStyle: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
              fontFamily: "Cairo",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          tabs: [
            Tab(text: AppLocalizations.of(context).surah),
            Tab(text: AppLocalizations.of(context).juz),
            Tab(text: AppLocalizations.of(context).hizbQurater),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
