abstract class SurahsEvent {}

class LoadSurahByIndex extends SurahsEvent {
  final int index;

  LoadSurahByIndex(this.index);
}

