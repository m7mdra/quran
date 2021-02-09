import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran/data/local/database_file.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/model/search_result.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/di.dart';
import 'package:quran/islamic_app_bar.dart';
import 'package:quran/page/surah_details/bloc/bookmark/add_bookmark_cubit.dart';
import 'package:quran/page/surah_details/bloc/reader/last_read_bloc.dart';
import 'package:quran/page/surah_details/bloc/readers/readers_bloc.dart';
import 'package:quran/page/surah_details/bloc/tafseer/tafseer_bloc.dart';
import 'package:quran/page/surah_details/bloc/tafseer/tafseer_event.dart';
import 'package:quran/page/surah_details/quran_controls_modal_widget.dart';
import 'package:quran/page/surah_details/search_delegate.dart';
import 'package:quran/page/surah_details/surah_player.dart';
import 'package:quran/page/surah_details/tafseer_widget.dart';

import '../../../popup_menu.dart';
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
                            builder: (context) => TestWidget(
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

class TestWidget extends StatefulWidget {
  final int page;

  const TestWidget({Key key, this.page}) : super(key: key);

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
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
            // _bookmarkCubit.saveBookMark(name, surah, position)
          },
          player: _player,
          page: _currentPage,
        ),
        height: _isVisible ? 120 : 0,
        width: MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 200),
      ),
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width, 60),
        child: AnimatedContainer(
          height: _isVisible ? 60 : 0,
          duration: Duration(milliseconds: 200),
          child: IslamicAppBar(
            title: 'Hello',
            actions: [
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
                  })
            ],
          ),
        ),
      ),
      body: SafeArea(
        maintainBottomViewPadding: true,
        top: true,
        child: GestureDetector(
          onTap: () {
            setState(() {
              _isVisible = !_isVisible;
            });
          },
          child: PageView.builder(
            clipBehavior: Clip.antiAlias,
            onPageChanged: (page) {
              setState(() {
                var firstInPage = getAyahForPage(page).first;
                _lastReadBloc.add(SaveReadingSurah(
                    firstInPage.surahName, firstInPage.pageId + 1, 0));
                _currentPage = page + 1;
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
                          textAlign: TextAlign.center,
                          softWrap: true),
                    ],
                  ));
            },
            itemCount: ayatByPage.values.length,
          ),
        ),
      ),
    );
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
        });
  }

  showTafseerDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return TafseerWidget();
        });
  }
}

class SurahTitleWidget extends StatelessWidget {
  final String surah;

  const SurahTitleWidget({Key key, this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset('assets/images/surah_name_title.svg'),
          Text(
            surah,
            style: TextStyle(
                color: Color(0xffFD9434),
                fontSize: 22,
                fontFamily: 'Al-QuranAlKareem'),
          )
        ],
      ),
    );
  }
}
