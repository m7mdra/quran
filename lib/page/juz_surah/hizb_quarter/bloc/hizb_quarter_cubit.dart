import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quran/data/local/model/hizb_quarter.dart';
import 'package:quran/data/local/quran_database.dart';

part 'hizb_quarter_state.dart';

class HizbQuarterCubit extends Cubit<HizbQuarterState> {
  final QuranDatabase _quranDatabase;

  HizbQuarterCubit(this._quranDatabase) : super(HizbQuarterInitial());

  void loadData() async {
    try {
      emit(HizbQuarterLoading());
      var data = await _quranDatabase.hizbQuarter();
      emit(HizbQuarterSuccess(data));
    } catch (error) {
      emit(HizbQuarterError());
    }
  }
}
