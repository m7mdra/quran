import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

void main() {
  var cubit = ProgressCubit(0);
  var bloc = DownloadBloc(DownloadState(), cubit);
  cubit.listen((value) {
    print(value);
  });

  bloc.listen((state) {
    print(state.toString());
  });
  bloc.add(DownloadFile());
}

class DownloadEvent {}

class DownloadState {}

class DownloadIdleState extends DownloadState {}

class DownloadLoadingState extends DownloadState {
  final int progress;

  DownloadLoadingState(this.progress);

  @override
  String toString() {
    // TODO: implement toString
    return "DownloadLoadingState: $progress";
  }
}

class DownloadSuccessState extends DownloadState {}

class DownloadErrorState extends DownloadState {}

class DownloadFile extends DownloadEvent {}

class DownloadProgressChange extends DownloadEvent {
  final int progress;

  DownloadProgressChange(this.progress);

  @override
  String toString() {
    // TODO: implement toString
    return "DownloadProgressChange: ${progress}";
  }
}

class ProgressCubit extends Cubit<double> {
  ProgressCubit(double state) : super(state);

  void update(double progress) {
    emit(progress);
  }
}

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final ProgressCubit progressCubit;

  DownloadBloc(DownloadState initialState, this.progressCubit)
      : super(initialState);
  var url =
      "https://rawcdn.githack.com/m7mdra/quran-project-files/63cb82423aad37b68ccc861ea21d962a5dee6003/رياض-الصالحين-من-كلام-سيد-المرسلين-kutub-pdf.net.pdf";

  @override
  Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
    if (event is DownloadProgressChange) {
      if (event.progress == 100) {
        yield DownloadSuccessState();
      } else {
        yield DownloadLoadingState(event.progress);
      }
    }
    if (event is DownloadFile) {
      try {
        var dio = Dio(BaseOptions());
        dio.interceptors.add(LogInterceptor());
        yield DownloadLoadingState(0);
        var response = await dio.download(url, File('./file.pdf').path,
            onReceiveProgress: (count, total) {
          var progress = ((count / total) * 100);
          progressCubit.update(progress);
        });
        if (response.statusCode == 200)
          yield DownloadSuccessState();
        else
          yield DownloadErrorState();
      } catch (error) {
        print(error);
        yield DownloadErrorState();
      }
    }
  }
}
