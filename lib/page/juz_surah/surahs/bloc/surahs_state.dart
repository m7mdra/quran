import 'package:quran/data/model/surah_response.dart';

abstract class SurahsState {}

class SurahLoadingState extends SurahsState {}

class SurahErrorState extends SurahsState {}

class SurahSuccessState extends SurahsState {
  final Surah surah;

  SurahSuccessState(this.surah);
}
