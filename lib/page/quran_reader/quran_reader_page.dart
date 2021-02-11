import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/database_file.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/model/search_result.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/di.dart';
import 'package:quran/page/quran_reader/quran_controls_modal_widget.dart';
import 'package:quran/page/quran_reader/search_delegate.dart';
import 'package:quran/page/quran_reader/surah_player.dart';
import 'package:quran/page/quran_reader/tafseer_widget.dart';
import 'package:quran/widget/popup_menu.dart';
import 'package:quran/widget/surah_title_widget.dart';
import 'package:share/share.dart';

import '../../widget/islamic_app_bar.dart';
import 'bloc/bookmark/add_bookmark_cubit.dart';
import 'bloc/reader/last_read_bloc.dart';
import 'bloc/readers/readers_bloc.dart';
import 'bloc/tafseer/tafseer_bloc.dart';
import 'bloc/tafseer/tafseer_event.dart';

class QuranReaderPage extends StatefulWidget {
  final int page;

  const QuranReaderPage({Key key, this.page}) : super(key: key);

  @override
  _QuranReaderPageState createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage> {
  QuranDatabase _quranDatabase = QuranDatabase(DatabaseFile());
  SurahPlayer _player;
  Map<int, List<Ayah>> ayatByPage = {};
  var _playingAyahId = 0;
  PageController _pageController;
  bool _isVisible = true;
  ScrollController _scrollController;
  ReadersBloc _readersBloc;
  var _currentPage;
  BookmarkCubit _bookmarkCubit;
  LastReadBloc _lastReadBloc;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _lastReadBloc = context.bloc();
    _scrollController = ScrollController();
    _currentPage = widget.page + 1;
    _bookmarkCubit = BookmarkCubit(DependencyProvider.provide());
    _readersBloc =
        ReadersBloc(DependencyProvider.provide(), DependencyProvider.provide());
    _player = SurahPlayer(_readersBloc, DependencyProvider.provide(),
        DependencyProvider.provide());
    _player.errorStream.listen((event) {
      if (mounted)
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('حصل خطا'),
                  content: Text('فشل تشغيل المقطع, حاول مرة اخرى'),
                ));
    });
    _player.currentPlayingIndex.listen((event) {
      if (mounted)
        setState(() {
          _playingAyahId = event;
        });
    });
    _scrollController.addListener(() {
      var position = _scrollController.position;
      if (position == null) return;
      if (position.userScrollDirection == ScrollDirection.reverse) {
        if (_isVisible)
          setState(() {
            _isVisible = false;
          });
      }
      if (position.userScrollDirection == ScrollDirection.forward) {
        if (!_isVisible)
          setState(() {
            _isVisible = true;
          });
      }
    });
    _quranDatabase.ayat().then((value) {
      setState(() {
        ayatByPage = groupBy(value, (ayah) => ayah.pageId);
        _pageController.jumpToPage(widget.page);
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: AnimatedContainer(
        child: QuranControlsModal(
          onSaveBookMarkClick: (name) {
            _bookmarkCubit.saveBookMark(name, _currentPage);
          },
          player: _player,
          page: _currentPage,
        ),
        height: _isVisible ? 120 : 0,
        width: MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 200),
      ),
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 70),
        child: AnimatedContainer(
          height: _isVisible ? 70 : 0,
          duration: Duration(milliseconds: 200),
          child: IslamicAppBar(
            title: 'Hello',
            actions: actions(context),
          ),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        top: true,
        child: GestureDetector(
          onScaleStart: (details) {
            _baseScaleFactor = _scaleFactor;
          },
          onScaleUpdate: (details) {
            setState(() {
              _scaleFactor = _baseScaleFactor * details.scale;
            });
          },
          onTap: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: PageView.builder(
              clipBehavior: Clip.antiAlias,
              onPageChanged: (page) {
                setState(() {
                  var firstInPage = getAyahForPage(page).first;
                  _lastReadBloc.add(SaveReadingSurah(
                      firstInPage.surahName, firstInPage.pageId - 1, 0));
                  _currentPage = page;
                });
              },
              controller: _pageController,
              itemBuilder: (context, page) {
                var ayatList = getAyahForPage(page);
                return SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 16),
                        Text.rich(
                          TextSpan(
                              text: "",
                              semanticsLabel: 'semanticsLabel',
                              style: TextStyle(
                                  fontFamily: 'alquran',
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                              children: ayatList.map((e) {
                                return buildAyahTextSpan(e, context);
                              }).toList()),
                          semanticsLabel: 'semanticsLabel',
                          textAlign: TextAlign.justify,
                          softWrap: true,
                          textDirection: TextDirection.rtl,
                          textScaleFactor: _scaleFactor,
                        ),
                      ],
                    ));
              },
              itemCount: ayatByPage.values.length,
            ),
          ),
        ),
      ),
    );
  }

  actions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.share),
          onPressed: () async {
            sharePage();
          }),
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            SearchResult result = await showSearch<SearchResult>(
                context: context,
                delegate: AyahSearchDelegate(
                    SearchBloc(DependencyProvider.provide())));
            if (result != null) {
              var ayah = result.ayah;
              print(ayah);
              _pageController.jumpToPage(ayah.pageId - 1);
              setState(() {
                _playingAyahId = ayah.number;
              });
            }
          }),
    ];
  }

  List<Ayah> getAyahForPage(int page) => ayatByPage.values.toList()[page];

  TextSpan buildAyahTextSpan(Ayah e, BuildContext context) {
    if (e.numberInSurah == 1)
      return TextSpan(children: [
        WidgetSpan(
            child: SurahTitleWidget(
          surah: e.surahName,
        )),
        TextSpan(text: "\n"),
        buildAyah(e, context)
      ]);
    else
      return buildAyah(e, context);
  }

  TextSpan buildAyah(Ayah e, BuildContext context) {
    return TextSpan(
        style: _playingAyahId == e.number
            ? TextStyle(
                backgroundColor: Theme.of(context).primaryColor.withAlpha(100))
            : null,
        text:
            "${e.text.replaceFirst("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "")} ﴿${e.numberInSurah}﴾",
        semanticsLabel: 'semanticsLabel',
        recognizer: DoubleTapGestureRecognizer()
          ..onDoubleTapDown = (tapDown) {
            showContextMenuAt(tapDown, context, e);
          });
  }

  void showContextMenuAt(
      TapDownDetails tapDown, BuildContext context, Ayah ayah) {
    var rect = Rect.fromCircle(center: tapDown.globalPosition, radius: 0);
    var popMenu = PopupMenu(context: context);
    popMenu.show(
        rect: rect,
        onPlayClick: () async {
          _player.playAyah(ayah);
        },
        onTafseerCallback: () async {
          context.bloc<TafseerBloc>().add(LoadTafseerForAyah(ayah.number));
          showTafseerDialog();
        },
        onShareClick: () {
          Share.share(ayah.text);
        });
  }

  showTafseerDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return TafseerWidget();
        });
  }

  void sharePage() {
    var page = getAyahForPage(_currentPage);
    String shareText = "";
    groupBy(page, (p) => p.surahName).forEach((key, value) {
      shareText +=
          key.toString() + "\n" + value.map((e) => e.text).join("\n") + "\n";
    });
    Share.share(shareText);
  }
}
