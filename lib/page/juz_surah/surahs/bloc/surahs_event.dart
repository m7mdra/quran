abstract class SurahsEvent {}

class LoadSurahListEvent extends SurahsEvent {}

class LoadSurahListIndexed extends SurahsEvent{
  final int index;

  LoadSurahListIndexed(this.index);
}
