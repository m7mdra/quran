import 'package:quran/data/model/reader.dart';

abstract class ReadersState {}

class ReadersLoadingState extends ReadersState {}

class ReadersErrorState extends ReadersState {}

class ReadersEmptyState extends ReadersState {}

class ReadersLoadedState extends ReadersState {
  final List<Reader> list;

  ReadersLoadedState(this.list);
}
