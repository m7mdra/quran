import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/data/model/reader.dart';
import 'package:quran/page/surah_details/bloc/readers/readers_bloc.dart';
import 'package:quran/page/surah_details/bloc/readers/readers_state.dart';

class SurahPlayer {
  final AudioPlayer _player = AudioPlayer(playerId: "quranId");
  final ReadersBloc _readersBloc;
  StreamController<int> _currentPlayingIndexController =
      StreamController.broadcast();

  Stream<int> get currentPlayingIndex => _currentPlayingIndexController.stream;

  Sink<int> get _currentPlayingIndexSink => _currentPlayingIndexController.sink;
  List<Ayah> _playlist = [];

  AudioPlayerState get _state => _player.state;

  bool get _isPlaying => _state == AudioPlayerState.PLAYING;

  bool get _isStopped => _state == AudioPlayerState.STOPPED;

  bool get _isCompleted => _state == AudioPlayerState.COMPLETED;

  bool get _isPaused => _state == AudioPlayerState.PAUSED;

  SurahPlayer(this._readersBloc) {
    WidgetsFlutterBinding.ensureInitialized();

    _player
      ..onPlayerError.listen((event) {
        print("onPlayerError $event");
      })
      ..onPlayerCommand.listen((event) {
        print("onPlayerCommand $event");
      })
      ..onPlayerStateChanged.listen((event) {
        print("onPlayerStateChanged $event");
      })
      ..onPlayerCompletion.listen(onCompletion);
  }

  void dispose() async {
    await _player.stop();
    await _player.release();
    _currentPlayingIndexController.close();
  }

  void clear() async {
    stop();
    _playlist.clear();
  }

  void stop() async {
    // if (!_isStopped) await _player.stop();
  }

  void playAyahList(List<Ayah> list) async {
    clear();
    _playlist.addAll(list);
    _currentPlayingIndexController.sink.add(0);
    _play();
  }

  void playAyah(Ayah ayah) {
    clear();
    _playlist.add(ayah);
    _currentPlayingIndexController.sink.add(0);
    _play();
  }

  void playSurah(Surah surah) {
    clear();
    _playlist.addAll(surah.ayahs);
    _currentPlayingIndexController.sink.add(0);
    _play();
  }

  void _play() async {
    var firstAyah = mapAyahToUrl(_playlist.first);
    print("playing $firstAyah");
    var result = await _player.setUrl(firstAyah);
    print("play with result $result");
    if (result == 1) {
      _player.resume();
      _playlist.removeAt(0);
    } else {}
  }

  void pause() async {
    await _player.pause();
  }

  void resume() async {
    await _player.resume();
  }

  String mapAyahToUrl(Ayah ayah) {
    return 'https://cdn.alquran.cloud/media/audio/ayah/ar.alafasy/${ayah.number}"';
  }

  void onCompletion(void event) {
    print(_playlist);
    print("onPlayerCompletion ");

    if (_playlist.isNotEmpty) {

    } else {
      stop();
    }
  }
}
