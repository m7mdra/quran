import 'package:quran/data/model/quran.dart';

abstract class SurahsState {}

class SurahsLoadingState extends SurahsState {}

class SurahsErrorState extends SurahsState {}

class SurahsLoadedSuccessState extends SurahsState {
  final List<Surah> surah;
  final int index;

  SurahsLoadedSuccessState(this.surah, [this.index = 0]);
}
