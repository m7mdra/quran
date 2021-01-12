import 'package:quran/data/model/tafseer.dart';

abstract class TafseerState {}

class TafseerLoadingState extends TafseerState {}

class TafseerErrorState extends TafseerState {}

class TafseerForAyahLoadedState extends TafseerState {
  final Tafseer tafseer;

  TafseerForAyahLoadedState(this.tafseer);
}

class TafseerForSurahLoadedState extends TafseerState {
  final List<Tafseer> list;

  TafseerForSurahLoadedState(this.list);
  @override
  String toString() {
    return "TafseerForSurahLoadedState ${list.length}";
  }
}
