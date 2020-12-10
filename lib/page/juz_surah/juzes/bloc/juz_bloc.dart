import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/network/quran_api.dart';

import 'juz_event.dart';
import 'juz_state.dart';

class JuzBloc extends Bloc<JuzEvent, JuzState> {
  final QuranApi _quranApi;

  JuzBloc(this._quranApi) : super(JuzLoadingState());

  @override
  Stream<JuzState> mapEventToState(JuzEvent event) async* {
    if (event is LoadJuzByIndex) {
      try {
        yield JuzLoadingState();
        var data = await _quranApi.juzByIndex(event.index);
        yield JuzSuccessState(data.juz);
      } catch (error){
        yield JuzErrorState();
      }
    }
  }
}
