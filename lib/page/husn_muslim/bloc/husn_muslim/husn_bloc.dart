import 'package:bloc/bloc.dart';
import 'package:quran/data/local/husn_proivder.dart';
import 'package:quran/data/model/husn.dart';

import 'husn_event.dart';
import 'husn_state.dart';

class HusnBloc extends Bloc<HusnEvent, HusnState> {
  final HusnProvider _provider;

  HusnBloc(this._provider) : super(HusnLoadingState());

  @override
  Stream<HusnState> mapEventToState(HusnEvent event) async* {
    if (event is LoadHusnData) {
      try {
        yield HusnLoadingState();
        List<Chapter> data = await _provider.load();
        yield HusnLoadedState(data);
      } catch (error) {
        yield HusnErrorState();
      }
    }
  }
}
