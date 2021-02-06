import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/di.dart';
import 'package:quran/page/surah_details/bloc/reader/last_read_bloc.dart';
import 'package:quran/page/surah_details/quran_controls_modal_widget.dart';
import 'package:quran/page/surah_details/search_delegate.dart';
import 'package:quran/page/surah_details/surah_player.dart';
import 'package:quran/page/surah_details/surah_widget.dart';
import 'package:quran/popup_menu.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../../islamic_app_bar.dart';
import 'bloc/readers/readers_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class QuranReaderPage extends StatefulWidget {
  final List<Surah> surahs;
  final int index;

  QuranReaderPage({Key key, this.surahs, this.index}) : super(key: key);

  @override
  _QuranReaderPageState createState() => _QuranReaderPageState();
}

class _QuranReaderPageState extends State<QuranReaderPage>
    with TickerProviderStateMixin {
  SurahPlayer _surahPlayer;
  LastReadBloc _quranReaderBloc;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  Surah _currentSurah;
  AyahSearchResult query;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      print(_controller.offset);
    });
    _quranReaderBloc = context.bloc<LastReadBloc>();
    _surahPlayer =
        SurahPlayer(context.bloc<ReadersBloc>(), DependencyProvider.provide());
    _surahPlayer.errorStream.listen((event) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context).error),
              ));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: widget.index);
    });

    itemPositionsListener.itemPositions.addListener(() {
      print(itemPositionsListener.itemPositions.value);

      var index = itemPositionsListener.itemPositions.value.first.index;
      var surah = widget.surahs[index];
      if (_currentSurah != surah) {
        // _quranReaderBloc.add(SaveReadingSurah(surah, index));
        _surahPlayer.stop();
        setState(() {
          this._currentSurah = surah;
        });
      }
    });
  }

  @override
  void dispose() {
    _surahPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    print("_currentSurah $_currentSurah");
    var surahs = widget.surahs;
    return Scaffold(
      bottomSheet: QuranControlsModal(
        surah: _currentSurah != null ? _currentSurah : surahs[widget.index],
        player: _surahPlayer,
      ),
      appBar: _buildIslamicAppBar(context),
      body: ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        initialScrollIndex: widget.index,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == 113 ? 300 : 0),
            child: SurahWidget(
              selectedAyahId: query?.ayah?.number ?? -1,
              player: _surahPlayer,
              surah: surahs[index],
            ),
          );
        },
        itemCount: surahs.length,
      ),
    );
  }

  IslamicAppBar _buildIslamicAppBar(BuildContext context) {
    return IslamicAppBar(
      context: context,
      title: _currentSurah?.name ?? ' ',
      height: 56,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () async {
            /*var result = await showSearch<AyahSearchResult>(
                context: context,
                delegate: AyahSearchDelegate(
                    SearchBloc(DependencyProvider.provide())));
            if (result != null) {
              setState(() {
                query = result;
              });
              var indexOfSurah = widget.surahs.indexOf(query.surah);
              if (indexOfSurah != -1)
                itemScrollController.jumpTo(index: indexOfSurah, alignment: 0);
            }*/
          },
        ),
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {},
        ),
      ],
    );
  }
}

enum FontOptions { normal, bold, large }

class ToggleableFontOptions extends StatelessWidget {
  final FontOptions option;
  final bool isSelected;

  ToggleableFontOptions.normal(this.isSelected) : option = FontOptions.normal;

  ToggleableFontOptions.bold(this.isSelected) : option = FontOptions.bold;

  ToggleableFontOptions.large(this.isSelected) : option = FontOptions.large;

  String get _text {
    switch (option) {
      case FontOptions.normal:
        return 'Aa';
      case FontOptions.bold:
        return 'B';
      case FontOptions.large:
        return 'Aa';
      default:
        return '';
    }
  }

  TextStyle style(BuildContext context) {
    switch (option) {
      case FontOptions.normal:
        return TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
          fontSize: 13,
          color: _textColor(context),
        );
      case FontOptions.bold:
        return TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w800,
          fontSize: 14,
          color: _textColor(context),
        );
      case FontOptions.large:
        return TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: _textColor(context));
      default:
        return TextStyle();
    }
  }

  Color _backgroundColor(BuildContext context) {
    return isSelected
        ? Color(0xff9CBD17).withAlpha((200 / 0.15).round())
        : Colors.transparent;
  }

  Color _borderColor(BuildContext context) {
    return isSelected ? Color(0xff9CBD17) : Theme.of(context).dividerColor;
  }

  Color _textColor(BuildContext context) {
    return isSelected
        ? Color(0xff9CBD17)
        : Theme.of(context).textTheme.bodyText1.color;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: _backgroundColor(context),
            border: Border.all(color: _borderColor(context)),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: style(context),
        ),
      ),
    );
  }
}
