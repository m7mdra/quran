import 'package:quran/data/model/reader.dart';

abstract class ReadersEvent {}

class LoadReaders extends ReadersEvent {}

class SetDefaultReader extends ReadersEvent {
  final Reader reader;

  SetDefaultReader(this.reader);
}

class LoadSelectedReader extends ReadersEvent {}

class FindReaderByKeyword extends ReadersEvent {
  final String query;

  FindReaderByKeyword(this.query);
}
