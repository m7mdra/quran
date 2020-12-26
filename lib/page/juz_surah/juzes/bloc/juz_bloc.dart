import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/quran_provider.dart';

import 'juz_event.dart';
import 'juz_state.dart';

class JuzBloc extends Bloc<JuzEvent, JuzState> {
  final QuranProvider _quranProvider;

  JuzBloc(this._quranProvider) : super(JuzsLoadingState());

  @override
  Stream<JuzState> mapEventToState(JuzEvent event) async* {
    if (event is LoadJuzListEvent) {
      try {
        yield JuzsLoadingState();
        var data = await _quranProvider.loadJuzList();
        yield JuzsSuccessState(data);
      } catch (error) {
        yield JuzsErrorState();
      }
    }
  }
}
