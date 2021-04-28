import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quran/common.dart';
import 'package:quran/data/local/model/surah.dart';
import 'package:quran/di.dart';
import 'package:quran/page/quran_reader/bloc/reader/last_read_bloc.dart';
import 'package:quran/page/quran_reader/quran_reader_page.dart';

import 'bloc/bloc.dart';

class SurahsPage extends StatefulWidget {
  @override
  _SurahsPageState createState() => _SurahsPageState();
}

class _SurahsPageState extends State<SurahsPage>
    with AutomaticKeepAliveClientMixin {
  SurahsBloc _bloc;
  LastReadBloc _lastReadBloc;

  @override
  void initState() {
    super.initState();
    _lastReadBloc = context.bloc();
    _bloc = SurahsBloc(DependencyProvider.provide());
    _bloc.add(LoadSurahListEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

      return Column(
        children: [
          Card(
            elevation: 0,
              margin:
                  const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(8),
                    border: InputBorder.none,
                    hintText: 'ابحث عن السور',
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    )),
                onChanged: (text) {
                  _bloc.add(FindSurahWithName(text));
                },
                onSubmitted: (text) {
                  _bloc.add(FindSurahWithName(text));
                },
              )),
          BlocBuilder(
            cubit: _bloc,
            builder: (BuildContext context, state) {
              if (state is SurahsLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SurahsLoadedSuccessState) {
                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      var surah = state.surah[index];

                      return BlocProvider.value(
                          value: _lastReadBloc,
                          child: SurahWidget(surah: surah));
                    },
                    itemCount: state.surah.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(height: 1);
                    },
                  ),
                );
              }
              return Center(
                  child: Text(AppLocalizations.of(context).failedToLoadData));
            },
          ),
        ],
      );
  }

  @override
  bool get wantKeepAlive => true;
}

class SurahWidget extends StatelessWidget {
  const SurahWidget({
    Key key,
    @required this.surah,
  }) : super(key: key);

  final Surah surah;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () {
        context
            .read<LastReadBloc>()
            .add(SaveReadingSurah(surah.name, surah.page, 0));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => QuranReaderPage(page: surah.page)));
      },
      leading: Text("﴿${surah.number}﴾",
          style: TextStyle(
            fontFamily: 'trado',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          )),
      title: Text(surah.name,
          style: TextStyle(
            fontFamily: 'trado',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          )),
      subtitle: Text("عدد الايات : ${surah.numberOfAyat} ",
          style: TextStyle(
            color: Color(0xff949393),
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
          )),
    );
  }
}
