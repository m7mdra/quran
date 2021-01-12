import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common.dart';
import 'package:quran/di.dart';
import 'package:quran/generated/l10n.dart';
import 'package:quran/page/husn_muslim/bloc/husn_muslim/bloc.dart';
import 'package:quran/page/husn_muslim/husn_reader_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../islamic_app_bar.dart';
import 'bloc/husn_muslim/bloc.dart';

class HusnMuslimPage extends StatefulWidget {
  @override
  _HusnMuslimPageState createState() => _HusnMuslimPageState();
}

class _HusnMuslimPageState extends State<HusnMuslimPage> {
  HusnBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HusnBloc(DependencyProvider.provide());
    _bloc.add(LoadHusnData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title:isArabic(context)? "حصن المسلم":"Muslims fortress",
        context: context,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Text(
              AppLocalizations.of(context).contents,
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(),
          Expanded(
            child: BlocBuilder(
              cubit: _bloc,
              builder: (BuildContext context, state) {
                if (state is HusnLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is HusnLoadedState) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      var chapter = state.list[index];
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HusnReaderPage(
                                        chapters: state.list,
                                        position: index,
                                      )));
                        },
                        title: Text(chapter.title),
                        leading: Text("${chapter.id}"),
                      );
                    },
                    itemCount: state.list.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(
                        height: 1,
                      );
                    },
                  );
                } else {
                  return Text(AppLocalizations.of(context).failedToLoadData);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
