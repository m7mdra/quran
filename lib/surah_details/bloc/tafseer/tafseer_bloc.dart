import 'package:bloc/bloc.dart';
import 'package:quran/data/local/tafseer_repository.dart';
import 'package:quran/surah_details/bloc/tafseer/tafseer_event.dart';
import 'package:quran/surah_details/bloc/tafseer/tafseer_state.dart';

class TafseerBloc extends Bloc<TafseerEvent, TafseerState> {
  final TafseerRepository _repository;

  TafseerBloc(this._repository) : super(TafseerLoadingState());

  @override
  Stream<TafseerState> mapEventToState(TafseerEvent event) async* {
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
