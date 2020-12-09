abstract class TafseerEvent{}

class LoadTafseerForAyah extends TafseerEvent{
  final int ayahId;

  LoadTafseerForAyah(this.ayahId);

}
class LoadTafseerForSurah extends TafseerEvent{
  final int surahId;

  LoadTafseerForSurah(this.surahId);

}