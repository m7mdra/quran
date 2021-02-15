import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/di.dart';
import 'package:quran/page/juz_surah/surahs/surahs_page.dart';
import 'package:quran/page/quran_reader/quran_reader_page.dart';

import 'bloc/bloc.dart';
import 'bloc/juz_bloc.dart';

class JuzPage extends StatefulWidget {
  @override
  _JuzPageState createState() => _JuzPageState();
}

class _JuzPageState extends State<JuzPage> with AutomaticKeepAliveClientMixin {
  JuzBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = JuzBloc(DependencyProvider.provide());
    _bloc.add(LoadJuzListEvent());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder(
        cubit: _bloc,
        builder: (BuildContext context, state) {
          if (state is JuzsLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is JuzsSuccessState) {
            return ListView.separated(
              itemBuilder: (context, index) {
                var juz = state.juz[index + 1];
                return ListTile(
                  dense: true,
                  onTap: () {
                    var page = juz.first.page;
                    print("JUMPING TO PAGE: $page");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return QuranReaderPage(
                        page: page - 1,
                      );
                    }));
                  },
                  leading: Text("﴿${index + 1}﴾",
                      style: TextStyle(
                        fontFamily: 'Al-QuranAlKareem',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      )),
                  title: Text("الجزء ${index + 1}",
                      style: TextStyle(
                        fontFamily: 'quran',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                  subtitle: Text("عدد السور : ${juz.length} ",
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff949393),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.normal,
                      )),
                );
              },
              itemCount: 30,
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          }
          return Center(
            child: Text('Failed to load juz data'),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
