import 'package:flutter/material.dart';
import 'package:quran/main/main.dart';
import 'package:quran/page/juz_surah/surahs/surahs_page.dart';

import '../../islamic_app_bar.dart';

class SurahsJuzesPage extends StatefulWidget {
  @override
  _SurahsJuzesPageState createState() => _SurahsJuzesPageState();
}

class _SurahsJuzesPageState extends State<SurahsJuzesPage>
    with TickerProviderStateMixin {
/*  PageController _pageController;
  TabController _tabController;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SurahsPage(),
      appBar: IslamicAppBar(
        context: context,
        title: 'سور القران ',
      ),
    );
  }
}
