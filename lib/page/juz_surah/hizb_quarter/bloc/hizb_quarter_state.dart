part of 'hizb_quarter_cubit.dart';

@immutable
abstract class HizbQuarterState {}

class HizbQuarterInitial extends HizbQuarterState {}

class HizbQuarterLoading extends HizbQuarterState {}

class HizbQuarterError extends HizbQuarterState {}

class HizbQuarterSuccess extends HizbQuarterState {
  final List<HizbQuarter> list;

  HizbQuarterSuccess(this.list);

  @override
  String toString() {
    return 'HizbQuarterSuccess{list: $list}';
  }
}
