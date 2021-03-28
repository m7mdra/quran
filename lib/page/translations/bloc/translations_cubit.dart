import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/model/edition.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/local/quran_database.dart';

part 'translations_state.dart';

class TranslationsCubit extends Cubit<TranslationsState> {
  final QuranDatabase _quranDatabase;
  final Preference _preference;

  TranslationsCubit(this._quranDatabase, this._preference)
      : super(TranslationsInitial());

  Future<void> loadData() async {
    try {
      emit(TranslationsLoading());
      var translation = _preference.translation();

      var result = await _quranDatabase.translationEditions();
      if (translation != null)
        result = result.map((e) {
          e.setSelected(e.isSelected(translation));
          return e;
        }).toList();
      emit(TranslationsSuccess(result));
    } catch (err) {
      print(err);
      emit(TranslationsError());
    }
  }

  Future saveSelection(int id) async {
    await _preference.saveTranslation(id);
    loadData();
  }
}
