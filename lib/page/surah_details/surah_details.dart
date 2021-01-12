import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/di.dart';
import 'package:quran/generated/l10n.dart';
import 'package:quran/islamic_app_bar.dart';
import 'package:quran/page/surah_details/bloc/bookmark/add_bookmark_cubit.dart';
import 'package:quran/page/surah_details/quran_controls_modal_widget.dart';
import 'package:quran/page/surah_details/surah_player.dart';
import 'package:quran/page/surah_details/surah_widget.dart';
import 'package:quran/page/surah_details/tafseer_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../popup_menu.dart';
import 'bloc/bookmark/add_bookmark_cubit.dart';
import 'bloc/bookmark/add_bookmark_state.dart';
import 'bloc/reader/last_read_bloc.dart';
import 'bloc/tafseer/tafseer_bloc.dart';
import 'bloc/tafseer/tafseer_event.dart';

class SurahDetails extends StatefulWidget {
  final Surah surah;
  final double offset;
  final int index;

  const SurahDetails({Key key, this.surah, this.offset = 0, this.index})
      : super(key: key);

  @override
  _SurahDetailsState createState() => _SurahDetailsState();
}

class _SurahDetailsState extends State<SurahDetails> {
  SurahPlayer _surahPlayer;
  int _playingAyahId = -1;
  BookmarkCubit bookmarkCubit;
  ScrollController _scrollController;
  LastReadBloc _quranReaderBloc;

  @override
  void initState() {
    super.initState();
    _quranReaderBloc = context.bloc();
    bookmarkCubit = BookmarkCubit(DependencyProvider.provide());
    _surahPlayer = SurahPlayer(context.bloc(), DependencyProvider.provide());
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.offset != 0) _scrollController.jumpTo(widget.offset);
    });

    _scrollController.addListener(() {
      _quranReaderBloc.add(SaveReadingSurah(
          widget.surah, widget.index, _scrollController.offset));
    });
    _surahPlayer.errorStream.listen((event) {
      if (mounted)
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('حصل خطا'),
                  content: Text('فشل تشغيل المقطع, حاول مرة اخرى'),
                ));
    });
    _surahPlayer.currentPlayingIndex.listen((event) {
      if (mounted)
        setState(() {
          _playingAyahId = event;
        });
    });
  }

  @override
  void dispose() {
    _surahPlayer.dispose();
    super.dispose();
  }

  showTafseerDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return TafseerWidget();
        });
  }

  void showContextMenuAt(
      TapDownDetails tapDown, BuildContext context, Ayah ayah) {
    var rect = Rect.fromCircle(center: tapDown.globalPosition, radius: 0);
    var popMenu = PopupMenu(context: context);
    popMenu.show(
        rect: rect,
        onPlayClick: () async {
          _surahPlayer.playAyah(ayah);
        },
        onTafseerCallback: () async {
          context.bloc<TafseerBloc>().add(LoadTafseerForAyah(ayah.number));
          showTafseerDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: QuranControlsModal(
        onSaveBookMarkClick: (name) {
          print(_scrollController.offset);

          bookmarkCubit.saveBookMark(
              name, widget.surah.number, _scrollController.offset);
        },
        surah: widget.surah,
        player: _surahPlayer,
      ),
      appBar: IslamicAppBar(
        title: widget.surah.name,
        context: context,
      ),
      body: BlocListener(
        cubit: bookmarkCubit,
        listener: (context, state) {
          if (state is AddBookmarkSavedFailed) {
            Navigator.of(context, rootNavigator: true).pop("dialog");
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: _roundedRectangleBorder,
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(MaterialLocalizations.of(context).okButtonLabel))
                      ],
                      title: Text(AppLocalizations.of(context).saveBookmarkDialogTitle),
                      content: Text(AppLocalizations.of(context).bookmarkSaveError),
                    ));
          }
          if (state is AddBookmarkSavedSuccess) {
            Navigator.of(context, rootNavigator: true).pop("dialog");
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      shape: _roundedRectangleBorder,
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(MaterialLocalizations.of(context).okButtonLabel))
                      ],
                      title: Text(AppLocalizations.of(context).saveBookmarkDialogTitle),
                      content: Text(AppLocalizations.of(context).bookmarkSaveSuccess),
                    ));
          }
          if (state is AddBookmarkSavedLoading) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                      content: Container(
                          height: 70,
                          width: 70,
                          child: Center(child: CircularProgressIndicator())),
                    ));
          }
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(
              top: 16.0, right: 16.0, left: 16.0, bottom: 150),
          child: Column(
            children: [
              SurahTitleWidget(
                surah: widget.surah,
              ),
              SizedBox(
                height: 16,
              ),
              Text.rich(
                TextSpan(
                    text: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيم \n",
                    semanticsLabel: 'semanticsLabel',
                    style: TextStyle(
                        fontFamily: 'alquran',
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                    children: widget.surah.ayahs.map((e) {
                      return TextSpan(
                          style: _playingAyahId == e.number
                              ? TextStyle(
                                  backgroundColor: Theme.of(context)
                                      .primaryColor
                                      .withAlpha(100))
                              : null,
                          text:
                              "${e.text.replaceFirst("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "")} ﴿${e.numberInSurah}﴾",
                          semanticsLabel: 'semanticsLabel',
                          recognizer: DoubleTapGestureRecognizer()
                            ..onDoubleTapDown = (tapDown) {
                              showContextMenuAt(tapDown, context, e);
                            });
                    }).toList()),
                semanticsLabel: 'semanticsLabel',
                textAlign: TextAlign.center,
                softWrap: true,
                textDirection: TextDirection.rtl,
              ),
            ],
          ),
        ),
      ),
    );
  }


  RoundedRectangleBorder get _roundedRectangleBorder =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
}
