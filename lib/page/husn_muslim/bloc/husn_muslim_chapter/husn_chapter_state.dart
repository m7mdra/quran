import 'package:quran/data/model/husn_chapter.dart';

abstract class HusnChapterState {}

class HusnChapterLoadingState extends HusnChapterState {}

class HusnChapterErrorState extends HusnChapterState {}

class HusnChapterLoadedState extends HusnChapterState {
  final HusnChapter chapter;

  HusnChapterLoadedState(this.chapter);
}
