import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/network/quran_api.dart';

import 'surahs_event.dart';
import 'surahs_state.dart';

class SurahsBloc extends Bloc<SurahsEvent, SurahsState> {
  final QuranApi _quranApi;

  SurahsBloc(this._quranApi) : super(SurahLoadingState());

  @override
  Stream<SurahsState> mapEventToState(SurahsEvent event) async* {
    if (event is LoadSurahByIndex) {
      try {
        yield SurahLoadingState();
        var data = await _quranApi.surahByIndex(event.index);
        yield SurahSuccessState(data.surah);
      } catch (error) {
        yield SurahErrorState();
      }
    }
  }
}
