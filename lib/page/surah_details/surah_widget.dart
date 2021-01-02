import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/page/surah_details/surah_player.dart';
import 'package:quran/page/surah_details/tafseer_widget.dart';
import 'package:quran/popup_menu.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/tafseer/tafseer_bloc.dart';
import 'bloc/tafseer/tafseer_event.dart';

class SurahWidget extends StatefulWidget {
  final Surah surah;
  final SurahPlayer player;
  final int selectedAyahId;

  const SurahWidget(
      {Key key, this.surah, this.player, this.selectedAyahId = -1})
      : super(key: key);

  @override
  _SurahWidgetState createState() => _SurahWidgetState();
}

class _SurahWidgetState extends State<SurahWidget> {
  int _playingAyahId = 0;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
    print(_scrollController.offset);
    });
    widget.player.currentPlayingIndex.listen((event) {
      if (mounted)
        setState(() {
          _playingAyahId = event;
        });
    });
  }

  showTafseerDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return TafseerWidget();
        });
  }

  void showContextMenuAt(TapDownDetails tapDown, BuildContext context,
      Ayah ayah) {
    var rect = Rect.fromCircle(center: tapDown.globalPosition, radius: 0);
    var popMenu = PopupMenu(context: context);
    popMenu.show(
        rect: rect,
        onPlayClick: () async {
          widget.player.playAyah(ayah);
        },
        onTafseerCallback: () async {
          context.bloc<TafseerBloc>().add(LoadTafseerForAyah(ayah.number));
          showTafseerDialog();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
         children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset('assets/images/surah_name_title.svg'),
              Text(
                widget.surah.name,
                style: TextStyle(
                    color: Color(0xffFD9434),
                    fontSize: 22,
                    fontFamily: 'Al-QuranAlKareem'),
              )
            ],
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
                children: widget.surah.ayahs
                    .map((e) => TextSpan(
                        style: _playingAyahId == e.number ||
                                widget.selectedAyahId == e.number
                            ? TextStyle(
                                backgroundColor:
                                    Theme.of(context).primaryColor.withAlpha(100))
                            : null,
                        text:
                            "${e.text.replaceFirst("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ", "")} ﴿${e.numberInSurah}﴾",
                        semanticsLabel: 'semanticsLabel',
                        recognizer: TapGestureRecognizer()
                          ..onTapDown = (tapDown) {
                            print(e.toJson());
                            showContextMenuAt(tapDown, context, e);
                          }))
                    .toList()),
            semanticsLabel: 'semanticsLabel',
            textAlign: TextAlign.center,
            softWrap: true,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
