import 'package:quran/data/model/dua_mathor.dart';

abstract class DuaMathorState {}

class DuaMathorLoadingState extends DuaMathorState {}

class DuaMathorErrorState extends DuaMathorState {}

class DuaMathorLoadedState extends DuaMathorState {
  final List<DuaMathor> list;

  DuaMathorLoadedState(this.list);
}
