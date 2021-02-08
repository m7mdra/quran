import 'package:bloc/bloc.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/page/surah_details/bloc/tafseer/tafseer_event.dart';
import 'package:quran/page/surah_details/bloc/tafseer/tafseer_state.dart';

class TafseerBloc extends Bloc<TafseerEvent, TafseerState> {
  final QuranDatabase _quranDatabase;

  TafseerBloc(this._quranDatabase) : super(TafseerLoadingState());

  @override
  Stream<TafseerState> mapEventToState(TafseerEvent event) async* {
    if (event is LoadTafseerForAyahRange) {
      try {
        yield TafseerLoadingState();
        var tafseerRange = await _quranDatabase.rangedTafseer(
            startId: event.start, endId: event.end);
        yield TafseerLoadedState(tafseerRange);
      } catch (error) {
        print(error);

        yield TafseerErrorState();
      }
    }
    if (event is LoadPageTafseer) {
      try {
        yield TafseerLoadingState();
        var tafseerRange = await _quranDatabase.pageTafseer(page: event.page);
        yield TafseerLoadedState(tafseerRange);
      } catch (error) {
        print(error);

        yield TafseerErrorState();
      }
    }
    if (event is LoadTafseerForAyah) {
      try {
        yield TafseerLoadingState();
        var ayahTafseer = await _quranDatabase.singleTafseer(id: event.ayahId);
        yield TafseerLoadedState(ayahTafseer);
      } catch (error) {
        print(error);
        yield TafseerErrorState();
      }
    }
  }
}
