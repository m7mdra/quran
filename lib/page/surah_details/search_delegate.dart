import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/quran_provider.dart';
import 'package:quran/data/model/quran.dart';
import '../../data/local/normalization.dart';
import 'package:rxdart/rxdart.dart';

class AyahSearchDelegate extends SearchDelegate<AyahSearchResult> {
  final SearchBloc _searchBloc;

  AyahSearchDelegate(this._searchBloc)
      : super(
            searchFieldStyle: TextStyle(color: Colors.grey),
            searchFieldLabel: 'ابحث عن ايات');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      color: Colors.white,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  TextStyle get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  Widget buildSuggestions(BuildContext context) {
    _searchBloc.add(SubmitQuery(query));

    return BlocBuilder(
      builder: (context, state) {
        if (state is SearchLoadingState) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is SearchEmptyState) {
          return Center(
            child: Text('لم يتم ايجاد كلمة مطابقة لكلمة البحث'),
          );
        }
        if (state is SearchSuccessState) {
          var result = state.result;

          return ListView.separated(
            itemBuilder: (context, index) {
              var surah = result[index].surah;
              var ayah = result[index].ayah;
              return ListTile(
                  onTap: () {
                    print(result[index]);
                    Navigator.pop(context, result[index]);
                  },
                  subtitle: Text(surah.name),
                  leading: Text('﴿${ayah.numberInSurah}﴾',
                      style: TextStyle(fontFamily: 'Al-QuranAlKareem')),
                  title: Text(ayah.text,
                      style: TextStyle(fontFamily: 'alquran', fontSize: 21)));
            },
            itemCount: result.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          );
        }
        if (state is SearchErrorState) {
          return Center(child: Text('فشل ايجاد ايات مطابقة لكلمة البحث'));
        }
        return Center(child: Text('قم بالبحث عن سورة او اية'));
      },
      cubit: _searchBloc,
    );
  }
}

class AyahSearchResult {
  final Surah surah;
  final Ayah ayah;

  AyahSearchResult(this.surah, this.ayah);

  @override
  String toString() {
    return "${surah.name} : $ayah";
  }
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final QuranProvider _provider;
  List<Surah> _cache;

  SearchBloc(this._provider) : super(SearchIdleState());

  @override
  Stream<Transition<SearchEvent, SearchState>> transformEvents(
      Stream<SearchEvent> events, transitionFn) {
    events = events.debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(events, transitionFn);
  }

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SubmitQuery) {
      if (event.query.isEmpty) return;
      try {
        yield SearchLoadingState();
        if (_cache == null) {
          _cache = await _provider.loadSurahList();
        }
        var result = await Future.microtask(() async {
          await Future.delayed(Duration(seconds: 1));
          List<AyahSearchResult> result = [];
          _cache.forEach((element) {
            var queryResult = element.ayahs.where((element) => element.text
                .replaceAll("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيم", "")
                .normalize()
                .contains(event.query));
            if (queryResult.isNotEmpty) {
              result.add(AyahSearchResult(element, queryResult.first));
            }
          });
          return result;
        });

        if (result.isNotEmpty) {
          yield SearchSuccessState(result);
        } else {
          yield SearchEmptyState();
        }
      } catch (error) {
        yield SearchErrorState();
      }
    }
  }
}

abstract class SearchState {}

class SearchLoadingState extends SearchState {}

class SearchEmptyState extends SearchState {}

class SearchErrorState extends SearchState {}

class SearchIdleState extends SearchState {}

class SearchSuccessState extends SearchState {
  final List<AyahSearchResult> result;

  SearchSuccessState(this.result);

  @override
  String toString() {
    return "$result";
  }
}

abstract class SearchEvent {}

class SubmitQuery extends SearchEvent {
  final String query;

  SubmitQuery(this.query);
}
