import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/model/search_result.dart';
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
import 'bloc/quran/quran_cubit.dart';
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
  SurahPlayer _player;
  var _playingAyahId = 0;
  PageController _pageController;
  bool _isVisible = true;
  ScrollController _scrollController;
  QuranCubit _quranCubit;
  ReadersBloc _readersBloc;
  int _currentPage;
  BookmarkCubit _bookmarkCubit;
  LastReadBloc _lastReadBloc;
  double _scaleFactor = 1.0;
  double _baseScaleFactor = 1.0;

  @override
  void initState() {
    super.initState();
    _lastReadBloc = context.bloc();
    _quranCubit = QuranCubit(DependencyProvider.provide(), _lastReadBloc);
    _quranCubit.loadData();
    _pageController = PageController();
    _scrollController = ScrollController();
    _currentPage = widget.page;
    _bookmarkCubit = BookmarkCubit(DependencyProvider.provide());
    _readersBloc =
        ReadersBloc(DependencyProvider.provide(), DependencyProvider.provide());
    _player =
        SurahPlayer(DependencyProvider.provide(), DependencyProvider.provide());
    _player.errorStream.listen((event) {
      if (mounted)
        showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(title: Text(AppLocalizations.of(context).error)));
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
  }

  @override
  void dispose() {
    _player.dispose();
    _scrollController.dispose();
    _pageController.dispose();
    _quranCubit.close();
    _readersBloc.close();
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
          height: _isVisible ? 80 : 0,
          duration: Duration(milliseconds: 200),
          child: IslamicAppBar(
            title: AppLocalizations.of(context).quranReader,
            actions: actions(context),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocListener(
          cubit: _quranCubit,
          listener: (context, state) {
            if (state is QuranSuccessState) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                _pageController.jumpToPage(widget.page - 1);
              });
            }
            if (state is OnSharePage) {
              Share.share(state.page);
            }
          },
          listenWhen: (previous, current) {
            return current is! QuranSuccessState || current is! OnSharePage;
          },
          child: BlocBuilder(
            buildWhen: (pre, current) {
              return current is! OnSharePage;
            },
            cubit: _quranCubit,
            builder: (context, state) {
              if (state is QuranLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is QuranSuccessState) {
                return quranPageView(state.ayat);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  GestureDetector quranPageView(Map<int, List<Ayah>> ayat) {
    return GestureDetector(
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
            _quranCubit.pageChanged(page + 1);
            setState(() {
              _currentPage = page + 1;
            });
          },
          controller: _pageController,
          itemBuilder: (context, page) {
            var ayatList = ayat[page + 1];
            if (page == 0) {
              return specialSurahPage(ayatList, context);
            } else if (page == 1) {
              return specialSurahPage(ayatList, context);
            } else {
              return Column(
                children: [
                  Expanded(child: ayatScrollView(ayatList, context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          "${AppLocalizations.of(context).juz} ${ayatList.first.juzId}",
                          style: TextStyle(fontSize: 16)),
                      Text(
                        "${AppLocalizations.of(context).page} ${page + 1}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                          "${AppLocalizations.of(context).hizbQurater} ${ayatList.first.hizbQuarterId}",
                          style: TextStyle(fontSize: 16)),
                    ],
                  )
                ],
              );
            }
          },
          itemCount: ayat.keys.length,
        ),
      ),
    );
  }

  Padding specialSurahPage(List<Ayah> ayatList, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment(0, -0.8),
        children: [
          SvgPicture.asset("assets/images/page_border.svg"),
          Align(
            alignment: Alignment(0, -0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ayatScrollView(ayatList, context),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget ayatScrollView(List<Ayah> ayatList, BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Text.rich(
          TextSpan(
              text: "",
              semanticsLabel: 'semanticsLabel',
              style: TextStyle(fontFamily: 'trado', fontSize: 30),
              children: ayatList.map((e) {
                return buildAyahTextSpan(e, context);
              }).toList()),
          semanticsLabel: 'semanticsLabel',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          textScaleFactor: _scaleFactor,
        ));
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

  TextSpan buildAyahTextSpan(Ayah e, BuildContext context) {
    if (e.numberInSurah == 1)
      return TextSpan(children: [
        TextSpan(text: "\n"),
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
        text: e.number == 1
            ? "${e.text} ﴿${e.numberInSurah}﴾"
            : "${e.text.replaceFirst("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "")} ﴿${e.numberInSurah}﴾",
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
    _quranCubit.sharePage(_currentPage + 1);
  }
}
