import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/model/tafseer.dart';

abstract class TafseerState {}

class TafseerLoadingState extends TafseerState {}

class TafseerErrorState extends TafseerState {}


class TafseerLoadedState extends TafseerState {
  final List<Ayah> list;

  TafseerLoadedState(this.list);
  @override
  String toString() {
    return "TafseerLoadedState ${list.length}";
  }
}
