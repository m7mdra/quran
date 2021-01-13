import 'package:flutter/material.dart';
import 'package:quran/common.dart';
import 'package:quran/page/notes_bookmarks/bookmark/bookmarks_page.dart';
import 'package:quran/page/notes_bookmarks/note/notes_page.dart';

import '../../islamic_app_bar.dart';
import '../../main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotesBookMarksPage extends StatefulWidget {
  @override
  _NotesBookMarksPageState createState() => _NotesBookMarksPageState();
}

class _NotesBookMarksPageState extends State<NotesBookMarksPage>
    with TickerProviderStateMixin {
  PageController _pageController;
  TabController _tabController;

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
        children: [BookmarksPage(), NotesPage()],
      ),
      appBar: IslamicAppBar(
        title:
            isArabic(context) ? 'العلامات والملاحظات' : 'Notes and Bookmarks',
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
              text: isArabic(context) ? 'العلامات' : 'Bookmarks',
            ),
            Tab(
              text: isArabic(context) ? 'الملاحظات' : 'Notes',
            )
          ],
          controller: _tabController,
        ),
        context: context,
      ),
    );
  }
}
