import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/data/model/reader.dart';
import 'package:quran/page/surah_details/bloc/readers/readers_bloc.dart';

import 'bloc/readers/readers_state.dart';

class SurahPlayer {
  AudioPlayer _player;
  final ReadersBloc _readersBloc;
  final Preference _preference;
  Reader _currentReader;
  StreamController<int> _currentPlayingIndexController =
      StreamController.broadcast();

  StreamController<String> _errorController = StreamController.broadcast();
  StreamController<AudioPlayerState> _playerStateChanged =
      StreamController.broadcast();

  Stream<AudioPlayerState> get onPlayerStateChanged =>
      _playerStateChanged.stream;

  Stream<int> get currentPlayingIndex => _currentPlayingIndexController.stream;

  Stream<String> get errorStream => _errorController.stream;
  List<Ayah> _playlist = [];

  AudioPlayerState get _state => _player.state;

  bool get _isPlaying => _state == AudioPlayerState.PLAYING;

  bool get _isStopped => _state == AudioPlayerState.STOPPED;

  bool get _isCompleted => _state == AudioPlayerState.COMPLETED;

  bool get _isPaused => _state == AudioPlayerState.PAUSED;

  SurahPlayer(this._readersBloc, this._preference) {
    WidgetsFlutterBinding.ensureInitialized();
    _player = AudioPlayer(playerId: "quranId");
    _preference.reader().then((value) => _currentReader = value);
    _readersBloc.listen((state) {
      if (state is DefaultReaderLoadedState) {
        _currentReader = state.reader;
      }
    });
    _player
      ..onPlayerError.listen((event) {
        _errorController.sink.add(event);
      })
      ..onPlayerStateChanged.listen((event) {
        print("onPlayerStateChanged $event");
        if (!_playerStateChanged.isClosed) _playerStateChanged.sink.add(event);
      })
      ..onPlayerCompletion.listen(onCompletion);
  }

  void dispose() async {
    await _player.stop();
    await _player.release();
    _errorController.close();
    _currentPlayingIndexController.close();
    _playerStateChanged.close();
  }

  void clear() async {
    stop();
    _playlist.clear();
  }

  void stop() async {
    if (!_isStopped) {
      _currentPlayingIndexController.sink.add(0);
      await _player.stop();
    }
  }

  void playAyahList(List<Ayah> list) async {
    clear();
    _playlist.addAll(list);
    _play();
  }

  void playAyah(Ayah ayah) {
    clear();
    _playlist.add(ayah);
    _play();
  }

  void playSurah(Surah surah) {
    clear();
    _playlist.addAll(surah.ayahs);
    _play();
  }

  void _play() async {
    var firstAyah = mapAyahToUrl(_playlist.first);
    _currentPlayingIndexController.sink.add(_playlist.first.number);

    var result = await _player.setUrl(firstAyah);
    if (result == 1) {
      await _player.resume();
      _playlist.removeAt(0);
    } else {
      _errorController.add("فشل تشغيل مقطع الصوت, حاول مجددا");
    }
  }

  void pause() async {
    if (_isPlaying && !_isPaused) await _player.pause();
  }

  void resume() async {
    if (!_isPaused && !_isPlaying) await _player.resume();
  }

  String mapAyahToUrl(Ayah ayah) {
    return 'https://cdn.alquran.cloud/media/audio/ayah/${_currentReader.identifier}/${ayah.number}';
  }

  void onCompletion(void event) {
    print(_playlist);
    print("onPlayerCompletion ");

    if (_playlist.isNotEmpty) {
      _play();
    } else {
      stop();
    }
  }
}
