import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/model/surah_response.dart';
import 'package:quran/di.dart';
import 'package:quran/juz_surah/surahs/bloc/bloc.dart';
import 'package:quran/surah_details/surah_details_page.dart';

class SurahsPage extends StatefulWidget {
  @override
  _SurahsPageState createState() => _SurahsPageState();
}

class _SurahsPageState extends State<SurahsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) {
          return IndexedSurahWidget(
            index: index + 1,
            onPress: (surah) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SurahDetailsPage(
                            surah: surah,
                          )));
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 1);
        },
        itemCount: 114,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class IndexedSurahWidget extends StatefulWidget {
  final int index;
  final Function(Surah) onPress;

  const IndexedSurahWidget({
    Key key,
    this.index,
    this.onPress,
  }) : super(key: key);

  @override
  _IndexedSurahWidgetState createState() => _IndexedSurahWidgetState();
}

class _IndexedSurahWidgetState extends State<IndexedSurahWidget>
    with AutomaticKeepAliveClientMixin {
  SurahsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SurahsBloc(DependencyProvider.provide());
    _bloc.add(LoadSurahByIndex(widget.index));
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _trailingWidgetForState(SurahsState state) {
    if (state is SurahLoadingState) {
      return SizedBox(
        child: CircularProgressIndicator(strokeWidth: 2),
        width: 20,
        height: 20,
      );
    }

    if (state is SurahErrorState) {
      return FlatButton(
          onPressed: () {
            _bloc.add(LoadSurahByIndex(widget.index));
          },
          child: Text('اعادة المحاولة'));
    }
    return null;
  }

  String _titleForState(SurahsState state) {
    if (state is SurahLoadingState) {
      return 'جاري تحميل السورة';
    }
    if (state is SurahSuccessState) {
      return state.surah.name;
    }
    if (state is SurahErrorState) {
      return 'فشل تحميل السورة';
    }
    return '';
  }

  Widget _subtitleWidgetForState(SurahsState state) {
    if (state is SurahLoadingState) {
      return Text('جاري التحميل');
    }
    if (state is SurahSuccessState) {
      return Text("عدد الايات : ${state.surah.ayahs.length} ",
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xff949393),
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
          ));
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return BlocBuilder(
      cubit: _bloc,
      builder: (BuildContext context, state) {
        return ListTile(
            trailing: _trailingWidgetForState(state),
            dense: true,
            onTap: state is SurahSuccessState
                ? () {
                    widget.onPress(state.surah);
                  }
                : null,
            leading: Text("﴿${widget.index}﴾",
                style: TextStyle(
                  fontFamily: 'Al-QuranAlKareem',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                )),
            title: Text(_titleForState(state),
                style: TextStyle(
                  fontFamily: 'alquran',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,
                )),
            subtitle: _subtitleWidgetForState(state));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
