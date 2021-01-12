import 'package:bloc/bloc.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/local/readers_provider.dart';

import 'readers_event.dart';
import 'readers_state.dart';

class ReadersBloc extends Bloc<ReadersEvent, ReadersState> {
  final Preference _preference;
  final ReadersProvider _provider;

  ReadersBloc(this._preference, this._provider) : super(ReadersLoadingState());

  @override
  Stream<ReadersState> mapEventToState(ReadersEvent event) async* {
    if (event is LoadSelectedReader) {
      var reader = await _preference.reader();
      yield DefaultReaderLoadedState(reader);
    }
    if (event is FindReaderByKeyword) {
      try {
        var readers = await _provider.load();
        var savedReader = await _preference.reader();
        var list = readers.map((element) {
          if (element.identifier == savedReader.identifier) {
            element.isSelect = true;
            return element;
          } else
            return element;
        }).toList();
        if (event.query.isEmpty) {
          yield ReadersLoadedState(list, savedReader);
          return;
        } else {
          var search = list
              .where((element) =>
                  element.name.contains(event.query) ||
                  element.englishName.toLowerCase().contains(event.query))
              .toList();
          if (search.isEmpty) {
            yield ReadersEmptyState();
          } else {
            yield ReadersLoadedState(search, savedReader);
          }
        }
      } catch (error) {
        print(error);
        yield ReadersErrorState();
      }
    }
    if (event is SetDefaultReader) {
      try {
        await _preference.saveReader(event.reader);
        yield DefaultReaderLoadedState(event.reader);
      } catch (error) {
        print(error);
      }
    }
    if (event is LoadReaders) {
      try {
        var readers = await _provider.load();
        var savedReader = await _preference.reader();
        var list = readers.map((element) {
          if (element.identifier == savedReader.identifier) {
            element.isSelect = true;
            return element;
          } else
            return element;
        }).toList();
        yield ReadersLoadedState(list, savedReader);
      } catch (error) {
        print(error);
        yield ReadersErrorState();
      }
    }
  }
}
