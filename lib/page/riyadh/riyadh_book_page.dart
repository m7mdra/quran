import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:quran/di.dart';
import 'package:quran/main.dart';

import '../../islamic_app_bar.dart';
import 'bloc/bloc.dart';

class RiyadhBookPage extends StatefulWidget {
  @override
  _RiyadhBookPageState createState() => _RiyadhBookPageState();
}

class _RiyadhBookPageState extends State<RiyadhBookPage> {
  RiyadhBookBloc _bookBloc;
  ProgressCubit _progressCubit;

  @override
  void initState() {
    super.initState();
    _progressCubit = ProgressCubit(0);
    _bookBloc = RiyadhBookBloc(
        DependencyProvider.provide(),
        DependencyProvider.provide(),
        _progressCubit,
        DependencyProvider.provide());
    _bookBloc.add(CheckBookExistence());
  }

  @override
  void dispose() {
    _progressCubit.close();
    _bookBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: IslamicAppBar(
          title: 'رياض الصالحين',
          context: context,
        ),
        body: BlocBuilder(
          cubit: _bookBloc,
          builder: (BuildContext context, state) {
            if (state is RiyadhBookNotFoundState) {
              return BlocProvider(
                create: (BuildContext context) {
                  return _bookBloc;
                },
                child: BookNotFoundWidget(),
              );
            }
            if (state is RiyadhBookSuccessState) {
              return _buildPdfView(state.filePath);
            }
            if (state is RiyadhBookErrorState) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      'فشل تحميل الملف, حاول مجددا',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    RaisedButton(
                      onPressed: () {
                        _bookBloc.add(DownloadBookEvent());
                      },
                      child: Text('اعادة التحميل'),
                    )
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              );
            }

            if (state is RiyadhBookFoundState) {
              return _buildPdfView(state.filePath);
            }
            if (state is RiyadhBookDownloadingState) {
              return BlocBuilder(
                cubit: _progressCubit,
                builder: (BuildContext context, int state) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'جاري تحميل الكتاب',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text('${state.toDouble()}%'),
                          LinearProgressIndicator(value: state * 0.01),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ));
  }

  Widget _buildPdfView(String path) {
    return PDFView(filePath: path, preventLinkNavigation: true);
  }
}

class BookNotFoundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book,
              size: 100,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'هذا الملف غير متوفر في الجهاز, سوف يقوم الجهاز بتحميله من الانترنت ليكون متوفر دائما',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: RaisedButton(
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                disabledElevation: 0,
                onPressed: () async {
                  context.bloc<RiyadhBookBloc>().add(DownloadBookEvent());
                },
                child: Text('تحميل'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
