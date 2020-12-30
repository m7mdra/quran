import 'package:quran/data/model/quran.dart';

abstract class JuzState {}

class JuzsLoadingState extends JuzState {}

class JuzsErrorState extends JuzState {}

class JuzsSuccessState extends JuzState {
  final List<Juz> juz;

  JuzsSuccessState(this.juz);
}
