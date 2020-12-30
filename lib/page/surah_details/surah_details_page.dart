import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/di.dart';
import 'package:quran/main.dart';
import 'package:quran/page/surah_details/search_delegate.dart';
import 'package:quran/page/surah_details/surah_player.dart';
import 'package:quran/page/surah_details/surah_widget.dart';
import 'package:quran/popup_menu.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'bloc/readers/readers_bloc.dart';
import 'bloc/readers/readers_event.dart';
import 'bloc/readers/readers_state.dart';
import 'bloc/tafseer/tafseer_bloc.dart';
import 'bloc/tafseer/tafseer_event.dart';
import 'bloc/tafseer/tafseer_state.dart';

class SurahDetailsPage extends StatefulWidget {
  final List<Surah> surahs;
  final int index;

  const SurahDetailsPage({Key key, this.surahs, this.index}) : super(key: key);

  @override
  _SurahDetailsPageState createState() => _SurahDetailsPageState();
}

class _SurahDetailsPageState extends State<SurahDetailsPage>
    with TickerProviderStateMixin {
  SurahPlayer _surahPlayer;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  Surah _currentSurah;
  MapEntry<Surah, Ayah> query;
  List<GlobalKey> keys;

  @override
  void initState() {
    super.initState();
    _surahPlayer =
        SurahPlayer(context.bloc<ReadersBloc>(), DependencyProvider.provide());
    _surahPlayer.errorStream.listen((event) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('حصل خطا'),
                content: Text('فشل تشغيل المقطع, حاول مرة اخرى'),
              ));
    });
    keys = widget.surahs
        .map((e) => GlobalKey(debugLabel: "surah:${e.number}"))
        .toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: widget.index, alignment: 0);
    });

    itemPositionsListener.itemPositions.addListener(() {
      var index = itemPositionsListener.itemPositions.value.first.index;
      var surah = widget.surahs[index];
      if (_currentSurah != surah) {
        _surahPlayer.stop();
        setState(() {
          this._currentSurah = surah;
        });
      }
      print(surah);
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
      bottomSheet: SuraInfoModalSheet(
        surah: _currentSurah != null ? _currentSurah : surahs[widget.index],
        player: _surahPlayer,
      ),
      appBar: IslamicAppBar(
        context: context,
        title: _currentSurah?.name ?? ' ',
        height: 56,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              var ayah = await showSearch<MapEntry<Surah, Ayah>>(
                  context: context,
                  delegate: AyahSearchDelegate(widget.surahs));
              if (ayah != null) {
                setState(() {
                  query = ayah;
                });
                itemScrollController.jumpTo(
                    index: widget.surahs.indexOf(ayah.key), alignment: 0);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: itemPositionsListener,
        initialScrollIndex: widget.index,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: index == 113 ? 400 : 0),
            child: SurahWidget(
              selectedAyahId: query?.value?.number ?? -1,
              player: _surahPlayer,
              surah: surahs[index],
            ),
          );
        },
        itemCount: surahs.length,
      ),
    );
  }
}

class TafseerWidget extends StatelessWidget {
  const TafseerWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        child: BlocBuilder(
          cubit: context.bloc<TafseerBloc>(),
          builder: (context, state) {
            if (state is TafseerForSurahLoadedState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("التفسير الميَّسر",
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal)),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        var tafseer = state.list[index];
                        return ListTile(
                          dense: true,
                          leading: Text(
                            "﴿${tafseer.ayaId}﴾",
                            style: TextStyle(
                                fontFamily: 'Al-QuranAlKareem', fontSize: 20),
                          ),
                          title: Text(tafseer.ayaInfo,
                              style: TextStyle(
                                fontFamily: 'alquran',
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              )),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('اغلاق'),
                  )
                ],
              );
            }
            if (state is TafseerForAyahLoadedState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("التفسير الميَّسر",
                        style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal)),
                    Divider(),
                    Text(state.tafseer.ayaInfo,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                    FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('اغلاق'),
                    )
                  ],
                ),
              );
            } else if (state is TafseerErrorState) {
              return Padding(
                padding: const EdgeInsets.all(48.0),
                child: Text(
                  'فشل ايجاد تفسير للاية',
                  style: TextStyle(
                      color: Theme.of(context).errorColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(48.0),
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

class ReadersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (query) {
                context.bloc<ReadersBloc>().add(FindReaderByKeyword(query));
              },
              decoration: InputDecoration(
                  hintText: "بحث باسم القارئ", suffixIcon: Icon(Icons.search)),
            ),
          ),
          BlocBuilder(
            cubit: context.bloc<ReadersBloc>(),
            builder: (BuildContext context, state) {
              if (state is ReadersLoadedState) {
                var list = state.list;
                return ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var reader = list[index];
                    return ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/images/readers_images/${reader.identifier}.jpg"))),
                          ),
                          VerticalDivider(),
                        ],
                      ),
                      selected: reader.isSelect,
                      dense: false,
                      trailing: reader.isSelect ? Icon(Icons.check_box) : null,
                      onTap: () {
                        context
                            .bloc<ReadersBloc>()
                            .add(SetDefaultReader(reader));
                        Navigator.pop(context);
                      },
                      title: Text(reader.name),
                      subtitle: Text(reader.englishName),
                    );
                  },
                  itemCount: list.length,
                );
              } else if (state is ReadersErrorState) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Text(
                      'فشل تحميل القارئين ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).errorColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                );
              } else if (state is ReadersEmptyState) {
                return Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Text(
                    'لم يتم ايجاد قارئيين بمفتاح البحث',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class SuraInfoModalSheet extends StatefulWidget {
  final Surah surah;
  final SurahPlayer player;

  const SuraInfoModalSheet({
    Key key,
    @required this.surah,
    this.player,
  }) : super(key: key);

  @override
  _SuraInfoModalSheetState createState() => _SuraInfoModalSheetState();
}

class _SuraInfoModalSheetState extends State<SuraInfoModalSheet> {
  SurahPlayer player;

  @override
  void initState() {
    super.initState();
    player = widget.player;

    context.bloc<ReadersBloc>().add(LoadSelectedReader());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocBuilder(
              cubit: context.bloc<ReadersBloc>(),
              builder: (BuildContext context, state) {
                return SuraOptions(
                  title: 'القارئ',
                  image: state is DefaultReaderLoadedState ||
                          state is ReadersLoadedState
                      ? 'assets/images/readers_images/${state.reader.identifier}.jpg'
                      : 'assets/images/choose_reader.svg',
                  onTap: () {
                    context.read<ReadersBloc>().add(LoadReaders());
                    showDialog(
                        context: context,
                        builder: (context) => ReadersWidget());
                  },
                );
              },
            ),
            SuraOptions(
              title: 'التفسير',
              image: 'assets/images/tafseer.svg',
              onTap: () {
                var list = widget.surah.ayahs;
                context.bloc<TafseerBloc>().add(
                    LoadTafseerForSurah(list.first.number, list.last.number));
                showDialog(
                    context: context, builder: (context) => TafseerWidget());
              },
            ),
            SuraOptions(
              title: 'حفظ',
              image: 'assets/images/bookmark_sura.svg',
              onTap: () {},
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xff95B93E), shape: BoxShape.circle),
                  child: StreamBuilder<AudioPlayerState>(
                      stream: player.onPlayerStateChanged,
                      builder: (context, snapshot) {
                        var state = snapshot.data;
                        return IconButton(
                          icon: state == AudioPlayerState.PLAYING
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          onPressed: () async {
                            player.playSurah(widget.surah);
                          },
                        );
                      }),
                ),
                Text('تشغيل',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ))
              ],
              mainAxisSize: MainAxisSize.min,
            )
          ],
        ),
      ),
      margin: EdgeInsets.zero,
    );
  }
}

class SuraOptions extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onTap;

  const SuraOptions({Key key, this.image, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (image.contains("svg"))
              SvgPicture.asset(image)
            else
              ClipOval(
                  child: Image.asset(
                image,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              )),
            Text(title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ))
          ],
        ),
      ),
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
