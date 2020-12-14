import 'package:bloc/bloc.dart';
import 'package:quran/data/local/dua_mathor_provider.dart';

import 'dua_mathor_event.dart';
import 'dua_mathor_state.dart';

class DuaMathorBloc extends Bloc<DuaMathorEvent, DuaMathorState> {
  final DuaMathorProvider _provider;

  DuaMathorBloc(this._provider) : super(DuaMathorLoadingState());

  @override
  Stream<DuaMathorState> mapEventToState(DuaMathorEvent event) async* {
    if (event is LoadDuaMathorData) {
      try {
        yield DuaMathorLoadingState();
        var data = await _provider.load();
        yield DuaMathorLoadedState(data);
      } catch (error) {
        yield DuaMathorErrorState();
      }
    }
  }
}
