import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/quran_database.dart';

import 'surahs_event.dart';
import 'surahs_state.dart';

class SurahsBloc extends Bloc<SurahsEvent, SurahsState> {
  final QuranDatabase _quranDatabase;

  SurahsBloc(this._quranDatabase) : super(SurahsLoadingState());

  @override
  Stream<SurahsState> mapEventToState(SurahsEvent event) async* {
    if (event is LoadSurahListIndexed) {
      try {
        yield SurahsLoadingState();
        var data = await _quranDatabase.surahById(event.index);
        yield SurahsLoadedSuccessState(data, event.index);
      } catch (error) {
        yield SurahsErrorState();
      }
    }
    if (event is LoadSurahListEvent) {
      try {
        yield SurahsLoadingState();
        var data = await _quranDatabase.surat();
        yield SurahsLoadedSuccessState(data);
      } catch (error) {
        yield SurahsErrorState();
      }
    }
  }
}
