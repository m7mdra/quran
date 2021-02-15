import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/model/search_result.dart';
import 'package:quran/data/local/model/surah.dart';
import 'package:quran/data/local/quran_database.dart';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AyahSearchDelegate extends SearchDelegate<SearchResult> {
  final SearchBloc _searchBloc;

  AyahSearchDelegate(this._searchBloc)
      : super(searchFieldStyle: TextStyle(color: Colors.grey));

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
            child: Text(AppLocalizations.of(context).searchEmpty),
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
                      style: TextStyle(fontFamily: 'trado', fontSize: 21)));
            },
            itemCount: result.length,
            separatorBuilder: (BuildContext context, int index) {
              return Divider();
            },
          );
        }
        if (state is SearchErrorState) {
          return Center(child: Text(AppLocalizations.of(context).searchFailed));
        }
        return Center(
            child: Text(AppLocalizations.of(context).searchPlaceHolder));
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
  final QuranDatabase _quranDatabase;

  SearchBloc(this._quranDatabase) : super(SearchIdleState());

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
        var result = await _quranDatabase.search(event.query);

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
  final List<SearchResult> result;

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
