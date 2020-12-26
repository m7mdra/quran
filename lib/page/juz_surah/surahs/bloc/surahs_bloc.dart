import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/quran_provider.dart';
import 'package:quran/data/network/quran_api.dart';

import 'surahs_event.dart';
import 'surahs_state.dart';

class SurahsBloc extends Bloc<SurahsEvent, SurahsState> {
  final QuranProvider quranProvider;

  SurahsBloc(this.quranProvider) : super(SurahsLoadingState());

  @override
  Stream<SurahsState> mapEventToState(SurahsEvent event) async* {
    if (event is LoadSurahListEvent) {
      try {
        yield SurahsLoadingState();
        var data = await quranProvider.loadSurahList();
        yield SurahsLoadedSuccessState(data);
      } catch (error) {
        yield SurahsErrorState();
      }
    }
  }
}
