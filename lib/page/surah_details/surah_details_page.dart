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
  AudioPlayer _audioPlayer = AudioPlayer();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  int _playingAyahId = 0;
  List<GlobalKey> keys;
  StreamController<Iterable<ItemPosition>> _scrollingPositions =
      StreamController();

  @override
  void initState() {
    super.initState();
    keys = widget.surahs
        .map((e) => GlobalKey(debugLabel: "surah:${e.number}"))
        .toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      itemScrollController.jumpTo(index: widget.index, alignment: 0);
    });
    _scrollingPositions.stream.timeout(Duration(seconds: 1)).listen((event) {
      print(event.first.index);
    });
    itemPositionsListener.itemPositions.addListener(() {
      _scrollingPositions.sink.add(itemPositionsListener.itemPositions.value);
    });
    _audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == AudioPlayerState.COMPLETED) {
        setState(() {
          _playingAyahId = 0;
        });
      }
    });
    _audioPlayer.onPlayerCommand.listen((event) {
      print(event);
    });

    _audioPlayer.onPlayerCommand.listen((event) {
      print(event);
    });
    _audioPlayer.onPlayerError.listen((event) {
      print(event);
      setState(() {
        _playingAyahId = 0;
      });
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content: Text('فشل تشغيل المقطع, حاول مرة اخرى'),
              ));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.stop();
  }

  Future<void> playAyah(int ayahId) async {
    var reader = await DependencyProvider.provide<Preference>().reader();

    _ensureNotPlaying();
    var url =
        "https://cdn.alquran.cloud/media/audio/ayah/${reader.identifier}/$ayahId";

    print("playing  $url...");

    var playStatus = await _audioPlayer.play(url);
    print(playStatus);
    if (playStatus == 1) {
      setState(() {
        _playingAyahId = ayahId;
      });
    }
  }

  void _ensureNotPlaying() {
    if (_audioPlayer.state == AudioPlayerState.PLAYING) {
      _audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    var surahs = widget.surahs;
    return Scaffold(
      /* bottomSheet: SuraInfoModalSheet(
        surah: widget.surah,
        player: _audioPlayer,
      ),*/
      appBar: IslamicAppBar(
        context: context,
        title: 'القران',
        height: 56,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              /*   var ayah = await showSearch<Ayah>(
                        context: context,
                        delegate: AyahSearchDelegate(widget.surah));*/
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
        itemBuilder: (context, index) {
          return SurahWidget(
            surah: surahs[index],
          );
        },
        itemCount: surahs.length,
      ),
    );
  }

  void showContextMenuAt(TapDownDetails tapDown, BuildContext context, Ayah e) {
    var rect = Rect.fromCircle(center: tapDown.globalPosition, radius: 0);
    var popMenu = PopupMenu(context: context);
    popMenu.show(
        rect: rect,
        onPlayClick: () async {
          playAyah(e.number);
        },
        onTafseerCallback: () async {
          context.bloc<TafseerBloc>().add(LoadTafseerForAyah(e.number));
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

class SurahWidget extends StatefulWidget {
  final Surah surah;
  final int playingAyahId;

  const SurahWidget({Key key, this.surah, this.playingAyahId})
      : super(key: key);

  @override
  _SurahWidgetState createState() => _SurahWidgetState();
}

class _SurahWidgetState extends State<SurahWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      primary: false,
      shrinkWrap: true,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 16),
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
              text: widget.surah.number == 1
                  ? ''
                  : "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيم \n",
              semanticsLabel: 'semanticsLabel',
              style: TextStyle(
                  fontFamily: 'alquran',
                  fontSize: 23,
                  fontWeight: FontWeight.bold),
              children: widget.surah.ayahs
                  .map((e) => TextSpan(
                      style: widget.playingAyahId == e.number
                          ? TextStyle(backgroundColor: Colors.black26)
                          : null,
                      text:
                          "${widget.surah.number == 1 ? e.text : e.text.replaceFirst("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", "")} ﴿${e.numberInSurah}﴾",
                      semanticsLabel: 'semanticsLabel',
                      recognizer: DoubleTapGestureRecognizer()
                        ..onDoubleTapDown = (tapDown) {
                          // showContextMenuAt(tapDown, context, e);
                        }))
                  .toList()),
          semanticsLabel: 'semanticsLabel',
          textAlign: TextAlign.center,
          softWrap: true,
          textDirection: TextDirection.rtl,
        ),
      ],
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
  final AudioPlayer player;

  const SuraInfoModalSheet({
    Key key,
    @required this.surah,
    this.player,
  }) : super(key: key);

  @override
  _SuraInfoModalSheetState createState() => _SuraInfoModalSheetState();
}

class _SuraInfoModalSheetState extends State<SuraInfoModalSheet> {
  AudioPlayer player;
  var _ayahs = <String>[];

  Future<void> prepareAyahs() async {
    var reader = await DependencyProvider.provide<Preference>().reader();

    _ayahs = widget.surah.ayahs
        .map((e) =>
            "https://cdn.alquran.cloud/media/audio/ayah/${reader.identifier}/${e.number}")
        .toList();
  }

  @override
  void initState() {
    super.initState();
    player = widget.player;

    context.bloc<ReadersBloc>().add(LoadSelectedReader());
    player.onPlayerCompletion.listen((event) async {
      print("ayahs.length ${_ayahs.length}");
      if (_ayahs.isNotEmpty) {
        await playAyah(_ayahs.first);
      } else {
        await player.stop();
      }
    });
  }

  Future<void> playAyah(String url) async {
    var playStatus = await player.setUrl(url);
    if (playStatus == 1) {
      await player.resume();
      _ayahs.removeAt(0);
    }
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
                            if (player.state == AudioPlayerState.PLAYING) {
                              await player.stop();
                            } else {
                              await prepareAyahs();
                              await playAyah(_ayahs.first);
                            }
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

class PlayButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: Color(0xff95B93E).withAlpha((255 / 0.16).round()),
              shape: BoxShape.circle),
        ),
        Container(
          width: 38,
          height: 38,
          child: IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () {},
            color: Colors.white,
          ),
          decoration:
              BoxDecoration(color: Color(0xff95B93E), shape: BoxShape.circle),
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

class AyahSearchDelegate extends SearchDelegate<Ayah> {
  final Surah surah;

  AyahSearchDelegate(this.surah)
      : super(
            searchFieldStyle: TextStyle(color: Colors.grey),
            searchFieldLabel: 'ابحث عن ايات');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    var result = findResult(query);
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
            onTap: () {
              Navigator.pop(context, result[index]);
            },
            leading: Text('﴿${result[index].numberInSurah}﴾',
                style: TextStyle(fontFamily: 'Al-QuranAlKareem')),
            title: Text(result[index].text,
                style: TextStyle(fontFamily: 'alquran', fontSize: 21)));
      },
      itemCount: result.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

  var tashkeel = ['ِ', 'ُ', 'ٓ', 'ٰ', 'ْ', 'ٌ', 'ٍ', 'ً', 'ّ', 'َ'];

  List<Ayah> findResult(String query) {
    if (query.isEmpty) return [];
    return surah.ayahs
        .where((element) => element.text
            .replaceAll('\u064b', '')
            .replaceAll('\u064f', '')
            .replaceAll('\u064c', '')
            .replaceAll('\u064d', '')
            .replaceAll('\u0650', '')
            .replaceAll('\u0651', '')
            .replaceAll('\u0652', '')
            .replaceAll('\u0653', '')
            .replaceAll('\u0654', '')
            .replaceAll('\u0655', '')
            .replaceAll('\u064e', '')
            .contains(query))
        .toList();
  }
}
