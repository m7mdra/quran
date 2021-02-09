import 'package:quran/data/local/model/ayah.dart';

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
