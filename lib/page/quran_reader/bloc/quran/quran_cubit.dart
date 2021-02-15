import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/page/quran_reader/bloc/reader/last_read_bloc.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranDatabase _quranDatabase;
  final LastReadBloc _lastReadBloc;

  QuranCubit(this._quranDatabase, this._lastReadBloc)
      : super(QuranInitialState());

  void pageChanged(int page) async {
    var result = await _quranDatabase.suratInPage(page);
    _lastReadBloc.add(SaveReadingSurah(result.first.name, page, 0.0));
  }

  void sharePage(int page) async {
    var result = await _quranDatabase.ayatInPage(page);
    String shareText = "";
    result.forEach((element) {
      shareText += element.text + "\n";
    });
    emit(OnSharePage(shareText));
  }

  void loadData() async {
    try {
      emit(QuranLoadingState());
      var ayat = await _quranDatabase.ayat();
      emit(QuranSuccessState(ayat));
    } catch (error) {
      print(error);
      emit(QuranErrorState());
    }
  }
}
