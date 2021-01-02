import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/model/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

part 'quran_reader_event.dart';

part 'quran_reader_state.dart';

class QuranReaderBloc extends Bloc<QuranReaderEvent, QuranReaderState> {
  final Preference _preferences;

  QuranReaderBloc(this._preferences) : super(QuranReaderInitial());

  @override
  Stream<QuranReaderState> mapEventToState(
    QuranReaderEvent event,
  ) async* {
    if (event is SaveReadingSurah) {
      await _preferences.saveReading(event.surah, event.position);
      yield QuranReaderLoaded(event.surah, event.position);
    }
    if (event is LoadLastReadingSurah) {
      var saved = await _preferences.getReading();
      yield QuranReaderLoaded(saved.value, saved.key);
    }
  }
}
