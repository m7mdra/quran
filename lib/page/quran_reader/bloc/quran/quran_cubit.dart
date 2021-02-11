import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/quran_database.dart';

part 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  final QuranDatabase _quranDatabase;

  QuranCubit(this._quranDatabase) : super(QuranInitialState());

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
