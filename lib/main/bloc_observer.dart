import 'package:bloc/bloc.dart';

class BlocTransitionObserver implements BlocObserver {
  @override
  void onChange(Cubit<dynamic> cubit, Change<dynamic> change) {
    print("onChange ${cubit.runtimeType} change: $change");
  }

  @override
  void onClose(Cubit<dynamic> cubit) {
    print("onClose ${cubit.runtimeType}");
  }

  @override
  void onCreate(Cubit<dynamic> cubit) {
    print("onCreate ${cubit.runtimeType}");
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print("${cubit.runtimeType} Error: $error $stackTrace");
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object event) {
    print("${bloc.runtimeType} EVENT: $event");
  }

  @override
  void onTransition(Bloc bloc, Transition<dynamic, dynamic> transition) {
    print("${bloc.runtimeType} Transition: $transition");
  }
}
