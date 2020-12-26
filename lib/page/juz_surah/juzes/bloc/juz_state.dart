import 'package:quran/data/model/juz_response.dart';

abstract class JuzState {}

class JuzsLoadingState extends JuzState {}

class JuzsErrorState extends JuzState {}

class JuzsSuccessState extends JuzState {
  final Juz juz;

  JuzsSuccessState(this.juz);
}
