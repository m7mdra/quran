import 'package:bloc/bloc.dart';
import 'package:quran/data/local/preference.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final Preference _preference;

  ThemeCubit(this._preference) : super(ThemeState(_preference.theme()));

  Future<void> dark() async {
    await _preference.setDarkTheme();
    emit(ThemeState(2));
  }

  Future<void> light() async {
    await _preference.setLightTheme();
    emit(ThemeState(1));
  }
}
