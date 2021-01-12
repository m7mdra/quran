part of 'last_read_bloc.dart';

@immutable
abstract class LastReadState {}

class LastReadInitial extends LastReadState {}

class LastReadLoaded extends LastReadState {
  final LastRead lastRead;

  LastReadLoaded(this.lastRead);
}
