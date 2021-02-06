import 'ayah.dart';
import 'surah.dart';

class SearchResult {
  Ayah ayah;
  Surah surah;

  SearchResult({this.ayah, this.surah});

  SearchResult.fromMap(Map<String, dynamic> map) {
    ayah = Ayah.fromMap(map);
    surah = Surah.fromMap(map);
  }
  @override
  String toString() {
    // TODO: implement toString
    return "SearchResult(ayah: $ayah, surah:$surah)";
  }
}
