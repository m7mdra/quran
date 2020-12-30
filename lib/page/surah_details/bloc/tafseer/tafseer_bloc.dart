import 'package:bloc/bloc.dart';
import 'package:quran/data/local/tafseer_repository.dart';
import 'package:quran/page/surah_details/bloc/tafseer/tafseer_event.dart';
import 'package:quran/page/surah_details/bloc/tafseer/tafseer_state.dart';

class TafseerBloc extends Bloc<TafseerEvent, TafseerState> {
  final TafseerRepository _repository;

  TafseerBloc(this._repository) : super(TafseerLoadingState());

  @override
  Stream<TafseerState> mapEventToState(TafseerEvent event) async* {
    if (event is LoadTafseerForSurah) {
      try {
        yield TafseerLoadingState();
        var surahTafseer =
            await _repository.getSurahTafseer(event.start, event.end);
        yield TafseerForSurahLoadedState(surahTafseer);
      } catch (error) {
        yield TafseerErrorState();
      }
    }
    if (event is LoadTafseerForAyah) {
      try {
        yield TafseerLoadingState();
        var ayahTafseer = await _repository.getSingleTafseer(event.ayahId);
        yield TafseerForAyahLoadedState(ayahTafseer);
      } catch (error) {
        yield TafseerErrorState();
      }
    }
  }
}
