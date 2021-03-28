import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/model/edition.dart';
import 'package:quran/data/local/quran_database.dart';

part 'translations_state.dart';

class TranslationsCubit extends Cubit<TranslationsState> {
  final QuranDatabase _quranDatabase;

  TranslationsCubit(this._quranDatabase) : super(TranslationsInitial());

  Future<void> loadData() async {
    try {
      emit(TranslationsLoading());
      var result = await _quranDatabase.translationEditions();
      emit(TranslationsSuccess(result));
    } catch (err) {
      emit(TranslationsError());
    }
  }
}
