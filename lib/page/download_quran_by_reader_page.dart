import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/data/model/reader.dart';
import 'package:quran/di.dart';
import 'package:quran/page/quran_reader/bloc/readers/readers_bloc.dart';
import 'package:quran/page/quran_reader/bloc/readers/readers_event.dart';
import 'package:quran/page/quran_reader/bloc/readers/readers_state.dart';
import 'package:quran/widget/islamic_app_bar.dart';

import '../common.dart';

class DownloadQuranByReaderPage extends StatefulWidget {
  const DownloadQuranByReaderPage({Key key}) : super(key: key);

  @override
  _DownloadQuranByReaderPageState createState() =>
      _DownloadQuranByReaderPageState();
}

class _DownloadQuranByReaderPageState extends State<DownloadQuranByReaderPage> {
  ReadersBloc _readersBloc;

  @override
  void initState() {
    super.initState();
    _readersBloc =
        ReadersBloc(DependencyProvider.provide(), DependencyProvider.provide());
    _readersBloc.add(LoadReaders());
  }

  @override
  void dispose() {
    super.dispose();
    _readersBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(title: "القراء"),
      body: BlocBuilder(
        cubit: _readersBloc,
        builder: (BuildContext context, state) {
          if (state is ReadersLoadedState) {
            var list = state.list;
            return ListView.separated(
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
                  dense: false,
                  onTap: () async {
                    List.generate(6236, (index) => mapAyahToUrl(index+1, reader))
                        .forEach((element) {
                          print(element);
                    });
                  },
                  title: Text(
                      isArabic(context) ? reader.name : reader.englishName),
                  subtitle: Text(
                      isArabic(context) ? reader.englishName : reader.name),
                );
              },
              itemCount: list.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  height: 1,
                );
              },
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(48.0),
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  String mapAyahToUrl(int ayahId, Reader reader) =>
      'https://cdn.alquran.cloud/media/audio/ayah/${reader.identifier}/${ayahId}';
}
