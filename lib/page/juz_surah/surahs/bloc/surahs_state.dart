import 'package:quran/data/model/quran.dart';

abstract class SurahsState {}

class SurahsLoadingState extends SurahsState {}

class SurahsErrorState extends SurahsState {}

class SurahsLoadedSuccessState extends SurahsState {
  final List<Surah> surah;

  SurahsLoadedSuccessState(this.surah);
}
