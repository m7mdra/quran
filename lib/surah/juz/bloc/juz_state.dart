import 'package:quran/data/model/juz_response.dart';

abstract class JuzState {}

class JuzLoadingState extends JuzState {}

class JuzErrorState extends JuzState {}

class JuzSuccessState extends JuzState {
  final Juz juz;

  JuzSuccessState(this.juz);
}
