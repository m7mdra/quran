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

import '../data/model/surah_response.dart';
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

  @override
  void initState() {
    super.initState();
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
                  onPressed: () {},
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
                  .map((e) => TextSpan(
                      text:
                          "${widget.surah.number == 1 ? e.text : e.text.replaceFirst("بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", "")} ﴿${e.numberInSurah}﴾",
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

  void showContextMenuAt(TapDownDetails tapDown, BuildContext context, Ayah e) {
    var rect = Rect.fromCircle(center: tapDown.globalPosition, radius: 0);
    var popMenu = PopupMenu(context: context);
    popMenu.show(
        rect: rect,
        onPlayClick: () {},
        onTafseerCallback: () async {
          context.bloc<TafseerBloc>().add(LoadTafseerForAyah(e.number));
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
                cubit: context.bloc<TafseerBloc>(),
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
        });
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        barrierColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return SuraInfoModalSheet(surah: widget.surah);
        });
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
              onChanged: (query){
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
                return  Padding(
                  padding: const EdgeInsets.all(48.0),
                  child: Text(
                    'لم يتم ايجاد قارئيين بمفتاح البحث',
                    textAlign: TextAlign.center,

                    style: TextStyle(
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
        ],
      ),
    );
  }
}

class SuraInfoModalSheet extends StatefulWidget {
  final Surah surah;

  const SuraInfoModalSheet({
    Key key,
    @required this.surah,
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
                        onTap: () {},
                      ),
                      SuraOptions(
                        title: 'التفسير الميسر',
                        image: 'assets/images/tafseer.svg',
                        onTap: () {
                          var list = widget.surah.ayahs;
                          context.bloc<TafseerBloc>().add(LoadTafseerForSurah(
                              list.first.number, list.last.number));
                        },
                      ),
                      SuraOptions(
                        title: 'إختيار القارئ',
                        image: 'assets/images/choose_reader.svg',
                        onTap: () {
                          context.read<ReadersBloc>().add(LoadReaders());
                          showDialog(
                              context: context,
                              builder: (context) => ReadersWidget());
                        },
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
            SvgPicture.asset(image),
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
