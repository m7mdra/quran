part of 'quran_cubit.dart';

@immutable
abstract class QuranState {}

class QuranInitialState extends QuranState {}
class QuranLoadingState extends QuranState{}
class QuranSuccessState extends QuranState{
  final Map<int, List<Ayah>> ayat;

  QuranSuccessState(this.ayat);

  @override
  String toString() {
    return 'QuranSuccessState{ayat: ${ayat.length}}';
  }
}
class QuranErrorState extends QuranState{}

