import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/di.dart';
import 'package:quran/page/quran_reader/quran_reader_page.dart';

import 'bloc/hizb_quarter_cubit.dart';

class HizbQuarterPage extends StatefulWidget {
  @override
  _HizbQuarterPageState createState() => _HizbQuarterPageState();
}

class _HizbQuarterPageState extends State<HizbQuarterPage>
    with AutomaticKeepAliveClientMixin {
  HizbQuarterCubit _hizbQuarterCubit;

  @override
  void initState() {
    super.initState();
    _hizbQuarterCubit = HizbQuarterCubit(DependencyProvider.provide());
    _hizbQuarterCubit.loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _hizbQuarterCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder(
      builder: (context, state) {
        if (state is HizbQuarterLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is HizbQuarterSuccess) {
          var list = state.list;
          return ListView.separated(
            itemBuilder: (context, index) {
              var quarter = list[index];
              return ListTile(
                leading: HizbIcon(
                  number: "$index",
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => QuranReaderPage(
                            page: quarter.pageId - 1,
                          )));
                },
                title: Text(
                  "ربع الحزب ${quarter.hizbQuarterId}",
                  style: TextStyle(
                    fontFamily: 'alquran',
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                subtitle: Text("صفحة رقم  ${quarter.pageId} ",
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: Color(0xff949393),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.normal,
                    )),
              );
            },
            itemCount: list.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 1);
            },
          );
        }
        return Container();
      },
      cubit: _hizbQuarterCubit,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HizbIcon extends StatelessWidget {
  final String number;

  const HizbIcon({Key key, this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(border: Border.all(width: 1, color: Theme
                .of(context)
                .primaryColor))),
        RotationTransition(
          turns: AlwaysStoppedAnimation(45 / 360),
          child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Theme
                      .of(context)
                      .primaryColor))),
        ),
        Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(border: Border.all(width: 1, color: Theme
                .of(context)
                .primaryColor), shape: BoxShape.circle)),

      ],
    );
  }
}
