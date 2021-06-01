import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common.dart';
import 'package:quran/di.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/islamic_app_bar.dart';
import 'bloc/bloc.dart';

class DuaMathorPage extends StatefulWidget {
  @override
  _DuaMathorPageState createState() => _DuaMathorPageState();
}

class _DuaMathorPageState extends State<DuaMathorPage> {
  DuaMathorBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DuaMathorBloc(DependencyProvider.provide());
    _bloc.add(LoadDuaMathorData());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: isArabic(context) ? 'ادعية ماثورة' : 'Duas Mathura',
        context: context,
      ),
      body: BlocBuilder(
        cubit: _bloc,
        builder: (BuildContext context, state) {
          if (state is DuaMathorLoadedState) {
            return ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) {
                var dua = state.list[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Text('${index + 1}'),
                  title: SelectableText(
                    dua.value,
                    toolbarOptions: ToolbarOptions(
                        copy: true, cut: true, selectAll: true, paste: true),
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 21, fontFamily: ''),
                  ),
                );
              },
              itemCount: state.list.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          } else if (state is DuaMathorLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Text(AppLocalizations.of(context).failedToLoadData);
          }
        },
      ),
    );
  }
}
