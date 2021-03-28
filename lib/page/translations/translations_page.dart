import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/di.dart';
import 'package:quran/widget/islamic_app_bar.dart';

import 'bloc/translations_cubit.dart';

class TranslationsPage extends StatefulWidget {
  @override
  _TranslationsPageState createState() => _TranslationsPageState();
}

class _TranslationsPageState extends State<TranslationsPage> {
  TranslationsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = TranslationsCubit(DependencyProvider.provide());
    _cubit.loadData();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(title: 'الترجمات'),
      body: BlocBuilder(
        cubit: _cubit,
        builder: (BuildContext context, state) {
          if (state is TranslationsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TranslationsSuccess) {
            var list = state.list;
            return ListView.separated(
              itemBuilder: (context, index) {
                var edition = list[index];
                return ListTile(
                  title: Text(edition.englishName),
                  subtitle: Text(edition.name),
                  leading: Text(edition.languageFromCode(),style: TextStyle(fontWeight: FontWeight.bold),),
                );
              },
              itemCount: list.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
