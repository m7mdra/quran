part of 'last_read_bloc.dart';

abstract class LastReadEvent {}

class SaveReadingSurah extends LastReadEvent {
  final String surah;
  final int page;
  final double position;

  SaveReadingSurah(this.surah, this.page, this.position);

  @override
  String toString() {
    return "$surah $page $position";
  }
}

class LoadLastReadingSurah extends LastReadEvent {}
