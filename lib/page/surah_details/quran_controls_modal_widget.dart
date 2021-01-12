import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/di.dart';
import 'package:quran/page/surah_details/surah_player.dart';
import 'package:quran/page/surah_details/tafseer_widget.dart';

import 'bloc/bookmark/add_bookmark_cubit.dart';
import 'bloc/bookmark/add_bookmark_state.dart';
import 'bloc/readers/readers_bloc.dart';
import 'bloc/readers/readers_event.dart';
import 'bloc/readers/readers_state.dart';
import 'bloc/tafseer/tafseer_bloc.dart';
import 'bloc/tafseer/tafseer_event.dart';

class QuranControlsModal extends StatefulWidget {
  final Surah surah;
  final SurahPlayer player;
  final Function(String) onSaveBookMarkClick;
  const QuranControlsModal({
    Key key,
    @required this.surah,
    this.player, this.onSaveBookMarkClick,
  }) : super(key: key);

  @override
  _QuranModalWidgetState createState() => _QuranModalWidgetState();
}

class _QuranModalWidgetState extends State<QuranControlsModal> {
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
        padding:
            const EdgeInsets.only(left: 8, right: 8, top: 16, bottom: 16),
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
              onTap: () async {
                var name = await showDialog<String>(
                    context: context,
                    builder: (context) => _showSaveBookmarkDialog());
                if (name != null) {
                  widget.onSaveBookMarkClick(name);
                }
              },
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

  AlertDialog _showSaveBookmarkDialog() {
    TextEditingController textEditingController = TextEditingController();
    return AlertDialog(
      title: Text('حفظ علامة قراءة'),
      shape: _roundedRectangleBorder,
      content: Column(
        children: [
          Text('قم بكتابة اسم علامة القراءة حتى يمكنك الرجع اليها لاحقا'),
          SizedBox(
            height: 16,
          ),
          TextField(
            maxLines: 1,
            controller: textEditingController,
            decoration: InputDecoration(
                isDense: true,
                hintText: 'مثال: سورة البقرة الاية ١٠',
                border: OutlineInputBorder()),
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: () {
                  var text = textEditingController.text;
                  if (text.isNotEmpty) {
                    Navigator.pop(context, text);
                  }
                },
                child: Text('حفظ'),
                focusElevation: 0,
                elevation: 0,
                disabledElevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('الغاء'),
              ),
            ],
          )
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  RoundedRectangleBorder get _roundedRectangleBorder =>
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
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
