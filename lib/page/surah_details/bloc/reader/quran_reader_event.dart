part of 'quran_reader_bloc.dart';

abstract class QuranReaderEvent {}

class SaveReadingSurah extends QuranReaderEvent {
  final Surah surah;
  final int position;

  SaveReadingSurah(this.surah, this.position);
  @override
  String toString() {
    return "${surah} $position";
  }
}

class LoadLastReadingSurah extends QuranReaderEvent {}
