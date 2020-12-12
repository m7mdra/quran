import 'package:bloc/bloc.dart';
import 'package:quran/data/local/husn_chapter_provider.dart';
import 'package:quran/data/model/husn_chapter.dart';

import 'husn_chapter_event.dart';
import 'husn_chapter_state.dart';

class HusnChapterBloc extends Bloc<HusnChapterEvent, HusnChapterState> {
  final HusnChapterProvider _provider;

  HusnChapterBloc(this._provider) : super(HusnChapterLoadingState());

  @override
  Stream<HusnChapterState> mapEventToState(HusnChapterEvent event) async* {
    if (event is LoadHusnChapterData) {
      try {
        yield HusnChapterLoadingState();
        HusnChapter data = await _provider.load(event.index);
        yield HusnChapterLoadedState(data);
      } catch (error) {
        yield HusnChapterErrorState();
      }
    }
  }
}
