import 'package:bloc/bloc.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/page/quran_reader/bloc/tafseer/tafseer_event.dart';
import 'package:quran/page/quran_reader/bloc/tafseer/tafseer_state.dart';

class TafseerBloc extends Bloc<TafseerEvent, TafseerState> {
  final QuranDatabase _quranDatabase;
  final Preference _preference;

  TafseerBloc(this._quranDatabase, this._preference)
      : super(TafseerLoadingState());

  @override
  Stream<TafseerState> mapEventToState(TafseerEvent event) async* {
    if (event is LoadTafseerForAyahRange) {
      try {
        yield TafseerLoadingState();
        var tafseerRange = await _quranDatabase.rangedTafseer(
            startId: event.start,
            endId: event.end,
            editionId: _preference.translation() ?? 103);
        yield TafseerLoadedState(tafseerRange);
      } catch (error) {
        print(error);

        yield TafseerErrorState();
      }
    }
    if (event is LoadPageTafseer) {
      try {
        yield TafseerLoadingState();
        var tafseerRange = await _quranDatabase.pageTafseer(
            page: event.page, editionId: _preference.translation() ?? 103);
        yield TafseerLoadedState(tafseerRange);
      } catch (error) {
        print(error);

        yield TafseerErrorState();
      }
    }
    if (event is LoadTafseerForAyah) {
      try {
        yield TafseerLoadingState();
        var ayahTafseer = await _quranDatabase.singleTafseer(
            id: event.ayahId, editionId: _preference.translation() ?? 103);
        yield TafseerLoadedState(ayahTafseer);
      } catch (error) {
        print(error);
        yield TafseerErrorState();
      }
    }
  }
}
