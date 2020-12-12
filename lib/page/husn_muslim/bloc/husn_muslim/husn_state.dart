import 'package:quran/data/model/husn.dart';
import 'package:quran/data/model/zekr.dart';

abstract class HusnState {}

class HusnLoadingState extends HusnState {}

class HusnErrorState extends HusnState {}

class HusnLoadedState extends HusnState {
  final List<Chapter> list;

  HusnLoadedState(this.list);
}
