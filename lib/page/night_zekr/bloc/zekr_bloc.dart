import 'package:bloc/bloc.dart';
import 'package:quran/data/local/zerk_provider.dart';
import 'package:quran/data/model/zekr.dart';
import 'package:quran/page/night_zekr/bloc/zekr_event.dart';
import 'package:quran/page/night_zekr/bloc/zekr_state.dart';

class ZekrBloc extends Bloc<ZekrEvent, ZekrState> {
  final ZekrProvider _provider;

  ZekrBloc(this._provider) : super(ZekrLoadingState());

  @override
  Stream<ZekrState> mapEventToState(ZekrEvent event) async* {
    if (event is LoadMorningZekr) {
      yield* _loadZekrByType("morning");
    }
    if (event is LoadNightZekr) {
      yield* _loadZekrByType("night");
    }
    if (event is LoadPostPrayerZekr) {
      yield* _loadZekrByType("postpray");
    }
  }

  Stream<ZekrState> _loadZekrByType(String type) async* {
    try {
      yield ZekrLoadingState();
      Zekr data;
      if (type == "morning") {
        data = await _provider.morning();
      } else if (type == "night") {
        data = await _provider.night();
      } else {
        data = await _provider.postPrayer();
      }
      yield ZekrLoadedState(data.content);
    } catch (error) {
      yield ZekrErrorState();
    }
  }
}
