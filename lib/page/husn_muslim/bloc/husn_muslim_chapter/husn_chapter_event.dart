abstract class HusnChapterEvent{}
class LoadHusnChapterData extends HusnChapterEvent{
  final int index;

  LoadHusnChapterData(this.index);
}