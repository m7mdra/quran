import 'package:bloc/bloc.dart';
import 'package:quran/data/local/preference.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  final Preference _preference;

  LanguageCubit(this._preference) : super(LanguageState(_preference.lang()));

  void load(){
    emit(LanguageState(_preference.lang()));
  }
  Future<void> ar() async {
    await _preference.saveCurrentLanguage('ar');
    emit(LanguageState('ar'));
  }

  Future<void> en() async {
    await _preference.saveCurrentLanguage('en');
    emit(LanguageState('en'));
  }
}
