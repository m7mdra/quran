import 'package:quran/data/model/zekr.dart';

abstract class ZekrState {}

class ZekrLoadingState extends ZekrState {}

class ZekrErrorState extends ZekrState {}

class ZekrLoadedState extends ZekrState {
  final List<Content> list;

  ZekrLoadedState(this.list);
}
