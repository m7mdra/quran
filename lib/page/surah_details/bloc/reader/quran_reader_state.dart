part of 'quran_reader_bloc.dart';

@immutable
abstract class QuranReaderState {}

class QuranReaderInitial extends QuranReaderState {}

class QuranReaderLoaded extends QuranReaderState {
  final Surah surah;
  final int position;

  QuranReaderLoaded(this.surah, this.position);
}
