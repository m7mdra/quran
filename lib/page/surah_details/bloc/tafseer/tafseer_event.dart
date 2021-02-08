abstract class TafseerEvent {}

class LoadTafseerForAyah extends TafseerEvent {
  final int ayahId;

  LoadTafseerForAyah(this.ayahId);
}

class LoadTafseerForAyahRange extends TafseerEvent {
  final int start;
  final int end;

  LoadTafseerForAyahRange(this.start, this.end);
}

class LoadPageTafseer extends TafseerEvent{
  final int page;

  LoadPageTafseer(this.page);
}