part of 'last_read_bloc.dart';

abstract class LastReadEvent {}

class SaveReadingSurah extends LastReadEvent {
  final Surah surah;
  final int index;
  final double position;

  SaveReadingSurah(this.surah, this.index, this.position);

  @override
  String toString() {
    return "${surah} $index $position";
  }
}

class LoadLastReadingSurah extends LastReadEvent {}
