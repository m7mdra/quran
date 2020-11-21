import 'package:flutter/material.dart';
import 'package:quran/main.dart';
import 'package:quran/quran_by_juz_page.dart';

import 'package:quran/quran_by_sura_page.dart';

class SurasPage extends StatefulWidget {
  @override
  _SurasPageState createState() => _SurasPageState();
}

class _SurasPageState extends State<SurasPage> with TickerProviderStateMixin {
  PageController _pageController;
  TabController _tabController;
  var currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pageController = PageController(keepPage: true);
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
        children: [
          QuranBySuraPage(),
          QuranByJuzPage()
        ],
      ),
      appBar: IslamicAppBar(
        title: 'سور القران ',
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
            Tab(
              text: 'السور',
            ),
            Tab(
              text: 'الاجزاء',
            )
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
