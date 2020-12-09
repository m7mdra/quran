import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/data/model/juz_response.dart';
import 'package:quran/main.dart';
import 'package:quran/popup_menu.dart';
import 'package:quran/surah_details/bloc/readers/readers_event.dart';
import 'package:quran/surah_details/bloc/readers/readers_state.dart';
import 'package:quran/surah_details/bloc/tafseer/tafseer_bloc.dart';
import 'package:quran/surah_details/bloc/tafseer/tafseer_event.dart';
import 'package:quran/surah_details/bloc/tafseer/tafseer_state.dart';

import '../data/local/readers_provider.dart';
import '../data/model/surah_response.dart';
import '../di.dart';
import 'bloc/readers/readers_bloc.dart';

class SurahDetailsPage extends StatefulWidget {
  final Surah surah;

  const SurahDetailsPage({Key key, this.surah}) : super(key: key);

  @override
  _SurahDetailsPageState createState() => _SurahDetailsPageState();
}

class _SurahDetailsPageState extends State<SurahDetailsPage>
    with TickerProviderStateMixin {
  var hideControls = false;
  TafseerBloc _tafseerBloc;
  ReadersBloc _readersBloc;

  @override
  void initState() {
    super.initState();
    _tafseerBloc = TafseerBloc(DependencyProvider.provide());
    _readersBloc =
        ReadersBloc(DependencyProvider.provide(), DependencyProvider.provide());
  }

  @override
  void dispose() {
    super.dispose();
    _tafseerBloc.close();
    _readersBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    return Scaffold(
      appBar: hideControls
          ? PreferredSize(child: Container(), preferredSize: Size.zero)
          : IslamicAppBar(
        context: context,
        title: widget.surah.name,
        height: 56,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              displayModalBottomSheet(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
             _readersBloc.add(LoadReaders());
             showReadersDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text.rich(
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
                  .map((e) =>
                  TextSpan(
                      text:
                      "${widget.surah.number == 1 ? e.text : e.text
                          .replaceFirst(
                          "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", "")} ﴿${e
                          .numberInSurah}﴾",
                      semanticsLabel: 'semanticsLabel',
                      recognizer: DoubleTapGestureRecognizer()
                        ..onDoubleTapDown = (tapDown) {
                          showContextMenuAt(tapDown, context, e);
                        }))
                  .toList()),
          semanticsLabel: 'semanticsLabel',
          textAlign: TextAlign.center,
          softWrap: true,
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }

  showReadersDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return ReadersWidget(readersBloc: _readersBloc);
        });
  }

  void showContextMenuAt(TapDownDetails tapDown, BuildContext context, Ayah e) {
    var rect = Rect.fromCircle(center: tapDown.globalPosition, radius: 0);
    var popMenu = PopupMenu(context: context);
    popMenu.show(
        rect: rect,
        onPlayClick: () {},
        onTafseerCallback: () async {
          _tafseerBloc.add(LoadTafseerForAyah(e.number));
          showTafseerDialog();
        });
  }

  showTafseerDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.all(16),
              child: BlocBuilder(
                cubit: _tafseerBloc,
                builder: (context, state) {
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
                            color: Theme
                                .of(context)
                                .errorColor,
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
        });
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return SuraInfoModalSheet();
        });
  }
}

class ReadersWidget extends StatelessWidget {
  const ReadersWidget({
    Key key,
    @required ReadersBloc readersBloc,
  }) : _readersBloc = readersBloc, super(key: key);

  final ReadersBloc _readersBloc;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocBuilder(
        cubit: _readersBloc,
        builder: (BuildContext context, state) {
          if(state is ReadersLoadedState){
            var list = state.list;
           return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                var reader = list[index];
                return ListTile(
                  selected: reader.isSelect,
                  dense: false,
                  trailing: reader.isSelect ? Icon(Icons.check_box) : null,
                  onTap: () {
                    _readersBloc.add(SetDefaultReader(reader));
                    // Navigator.pop(context);
                  },
                  title: Text(reader.name),
                  subtitle: Text(reader.englishName),
                );
              },
              itemCount: list.length,
            );
          }
          else if(state is ReadersErrorState){
            return Padding(
              padding: const EdgeInsets.all(48.0),
              child: Text(
                'فشل تحميل القارئين ',
                style: TextStyle(
                    color: Theme
                        .of(context)
                        .errorColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            );
          }
          else{
            return Padding(
              padding: const EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            );
          }
        },

      ),
    );
  }
}

class SuraInfoModalSheet extends StatefulWidget {
  const SuraInfoModalSheet({
    Key key,
  }) : super(key: key);

  @override
  _SuraInfoModalSheetState createState() => _SuraInfoModalSheetState();
}

class _SuraInfoModalSheetState extends State<SuraInfoModalSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        child: Stack(
          children: [
            Align(
              child: PlayButtonWidget(),
              alignment: AlignmentDirectional(0.0, -1.65),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("سُورة البَقَرةْ",
                          style: TextStyle(
                            fontFamily: 'alquran',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                      Text("بدء الإستماع",
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          )),
                      Text("الجزْءُ الأَّوَلْ",
                          style: TextStyle(
                            fontFamily: 'alquran',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SuraOptions(
                        title: 'حفظ الصفحة',
                        image: 'assets/images/bookmark_sura.svg',
                      ),
                      SuraOptions(
                        title: 'التفسير الميسر',
                        image: 'assets/images/tafseer.svg',
                      ),
                      SuraOptions(
                        title: 'إختيار القارئ',
                        image: 'assets/images/choose_reader.svg',
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      ),
    );
  }
}

class SuraOptions extends StatelessWidget {
  final String image;
  final String title;

  const SuraOptions({Key key, this.image, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(image),
        Text(title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            ))
      ],
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
          width: 75,
          height: 75,
          decoration: BoxDecoration(
              color: Color(0xff95B93E).withAlpha((255 / 0.16).round()),
              shape: BoxShape.circle),
        ),
        Container(
          width: 55,
          height: 55,
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
    return isSelected ? Color(0xff9CBD17) : Theme
        .of(context)
        .dividerColor;
  }

  Color _textColor(BuildContext context) {
    return isSelected
        ? Color(0xff9CBD17)
        : Theme
        .of(context)
        .textTheme
        .bodyText1
        .color;
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
