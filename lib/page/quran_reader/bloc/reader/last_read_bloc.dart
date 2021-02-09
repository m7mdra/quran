import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/model/last_read.dart';
import 'package:rxdart/rxdart.dart';

part 'last_read_event.dart';

part 'last_read_state.dart';

class LastReadBloc extends Bloc<LastReadEvent, LastReadState> {
  final Preference _preferences;

  LastReadBloc(this._preferences) : super(LastReadInitial());

  @override
  Stream<Transition<LastReadEvent, LastReadState>> transformEvents(
      Stream<LastReadEvent> events, transitionFn) {
    final nonDebounceStream =
        events.where((event) => event is! SaveReadingSurah);
    final debounceStream = events
        .where((element) => element is SaveReadingSurah)
        .debounceTime(Duration(milliseconds: 500));

    return super.transformEvents(
        MergeStream([nonDebounceStream, debounceStream]), transitionFn);
  }

  @override
  Stream<LastReadState> mapEventToState(
    LastReadEvent event,
  ) async* {
    if (event is SaveReadingSurah) {
      print("CALLLLLLLLED ${DateTime.now()}");
      var lastRead = LastRead(
          surah: event.surah, position: event.position, page: event.page);
      await _preferences.saveReading(lastRead);
      yield LastReadLoaded(lastRead);
    }
    if (event is LoadLastReadingSurah) {
      var saved = await _preferences.getReading();
      yield LastReadLoaded(saved);
    }
  }
}
