import 'package:quran/data/local/model/juz.dart';

abstract class JuzState {}

class JuzsLoadingState extends JuzState {}

class JuzsErrorState extends JuzState {}

class JuzsSuccessState extends JuzState {
  final Map<int, List<JuzReference>> juz;

  JuzsSuccessState(this.juz);
}
