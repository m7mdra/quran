import 'package:quran/data/model/tafseer.dart';

abstract class TafseerRepository {
  Future<Tafseer> getSingleTafseer(int ayahId);

  Future<List<Tafseer>> getSurahTafseer(int start, int end);
}
