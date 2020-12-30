import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/main.dart';
import 'package:quran/page/night_zekr/bloc/bloc.dart';
import 'package:quran/page/night_zekr/night_zekr_page.dart';

import '../../di.dart';

class MorningZekrPage extends StatefulWidget {
  @override
  _MorningZekrPageState createState() => _MorningZekrPageState();
}

class _MorningZekrPageState extends State<MorningZekrPage> {
  ZekrBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ZekrBloc(DependencyProvider.provide());
    _bloc.add(LoadMorningZekr());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(title: 'اذكار الصباح', context: context),
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
