import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/di.dart';
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
          if(state is JuzsLoadingState){
            return Center(child: CircularProgressIndicator(),);
          }
          if(state is JuzsSuccessState){
            return ListView.separated(
              itemBuilder: (context, index) {
                var juz = state.juz[index];
               return  ListTile(
                  dense: true,
                  onTap:  () {

                  },
                  leading: Text("﴿${juz.number}﴾",
                      style: TextStyle(
                        fontFamily: 'Al-QuranAlKareem',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      )),
                  title: Text("الجزء ${juz.number}",
                      style: TextStyle(
                        fontFamily: 'alquran',
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      )),
                  subtitle: Text("عدد السور : ${juz.surahs.length} ",
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
          return Center(child: Text('Failed to load juz data'),);
        },

      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
