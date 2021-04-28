abstract class SurahsEvent {}

class LoadSurahListEvent extends SurahsEvent {}

class FindSurahWithName extends SurahsEvent {
  final String name;

  FindSurahWithName(this.name);
}

class LoadSurahListIndexed extends SurahsEvent {
  final int index;

  LoadSurahListIndexed(this.index);
}
