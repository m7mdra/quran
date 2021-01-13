import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common.dart';
import 'package:quran/main.dart';
import 'package:quran/page/night_zekr/bloc/bloc.dart';
import 'package:quran/page/night_zekr/night_zekr_page.dart';

import '../../di.dart';
import '../../islamic_app_bar.dart';

class PostPrayerZekrPage extends StatefulWidget {
  @override
  _PostPrayerZekrPageState createState() => _PostPrayerZekrPageState();
}

class _PostPrayerZekrPageState extends State<PostPrayerZekrPage> {
  ZekrBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ZekrBloc(DependencyProvider.provide());
    _bloc.add(LoadPostPrayerZekr());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
          title: isArabic(context) ? 'اذكار الصلاة' : 'Prayer Doaa',
          context: context),
      body: BlocBuilder(
        cubit: _bloc,
        builder: (BuildContext context, state) {
          print(state);
          if (state is ZekrLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ZekrLoadedState) {
            var zekr = state.list;
            return ListView.builder(
              itemBuilder: (context, index) {
                var item = zekr[index];

                return ZekrWidget(
                  item: item,
                  indexInList: index,
                );
              },
              itemCount: zekr.length,
            );
          } else
            return Container();
        },
      ),
    );
  }
}
