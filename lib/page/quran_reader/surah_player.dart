import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quran/data/local/model/ayah.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/data/model/reader.dart';

class SurahPlayer {
  AudioPlayer _player;
  final Preference _preference;
  final QuranDatabase quranDatabase;
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

  bool get isPlaying => _state == AudioPlayerState.PLAYING;

  bool get isStopped => _state == AudioPlayerState.STOPPED;

  bool get isCompleted => _state == AudioPlayerState.COMPLETED;

  bool get isPaused => _state == AudioPlayerState.PAUSED;

  SurahPlayer(this._preference, this.quranDatabase) {
    WidgetsFlutterBinding.ensureInitialized();
    _player = AudioPlayer(playerId: "quranId");

    _preference.reader().then((value) => _currentReader = value);

    _player
      ..onPlayerError.listen((event) {
        if (!_errorController.isClosed) {
          _errorController.sink.add(event);
        }
      })
      ..onPlayerStateChanged.listen((event) {
        if (!_playerStateChanged.isClosed) {
          _playerStateChanged.sink.add(event);
        }
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
    if (!isStopped) {
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

  void playPage(int page) async {
    print("loading ayat in page $page");
    var ayat = await quranDatabase.ayatInPage(page);

    clear();
    _playlist.addAll(ayat);
    _play();
  }

  void _play() async {
    var firstAyah = await mapAyahToUrl(_playlist.first);

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
    if (isPlaying && !isPaused) await _player.pause();
  }

  void resume() async {
    if (!isPaused && !isPlaying) await _player.resume();
  }

  Future<String> mapAyahToUrl(Ayah ayah) async {
    _currentReader = await _preference.reader();
    return 'https://cdn.alquran.cloud/media/audio/ayah/${_currentReader.identifier}/${ayah.number}';
  }

  void onCompletion(void event) {
    if (_playlist.isNotEmpty) {
      _play();
    } else {
      stop();
    }
  }
}
