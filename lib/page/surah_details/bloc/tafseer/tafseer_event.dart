abstract class TafseerEvent {}

class LoadTafseerForAyah extends TafseerEvent {
  final int ayahId;

  LoadTafseerForAyah(this.ayahId);
}

class LoadTafseerForSurah extends TafseerEvent {
  final int start;
  final int end;

  LoadTafseerForSurah(this.start, this.end);
}
