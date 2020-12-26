import 'package:quran/data/model/reader.dart';

abstract class ReadersState {}

class ReadersLoadingState extends ReadersState {}

class ReadersErrorState extends ReadersState {}

class ReadersEmptyState extends ReadersState {}
class DefaultReaderLoadedState extends ReadersState{
  final Reader reader;

  DefaultReaderLoadedState(this.reader);
}

class ReadersLoadedState extends ReadersState {
  final List<Reader> list;
  final Reader reader;
  ReadersLoadedState(this.list, this.reader);
}
