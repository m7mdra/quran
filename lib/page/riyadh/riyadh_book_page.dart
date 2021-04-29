import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:quran/common.dart';
import 'package:quran/di.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../widget/islamic_app_bar.dart';
import 'bloc/bloc.dart';

class RiyadhBookPage extends StatefulWidget {
  @override
  _RiyadhBookPageState createState() => _RiyadhBookPageState();
}

class _RiyadhBookPageState extends State<RiyadhBookPage> {
  RiyadhBookBloc _bookBloc;
  ProgressCubit _progressCubit;
  PdfController _pdfController;
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
          title: isArabic(context) ? 'رياض الصالحين' : 'Righteous Riyadh',
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
                    MaterialButton(
                      onPressed: () {
                        _bookBloc.add(DownloadBookEvent());
                      },
                      child: Text(AppLocalizations.of(context).retry),
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
                            AppLocalizations.of(context).downloadingFile,
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
    _pdfController=PdfController(document: PdfDocument.openFile(path));
    return PdfView(controller: _pdfController);
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
              AppLocalizations.of(context).downloadNotFound,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              child: MaterialButton(
                elevation: 0,
                focusElevation: 0,
                highlightElevation: 0,
                hoverElevation: 0,
                disabledElevation: 0,
                onPressed: () async {
                  context.bloc<RiyadhBookBloc>().add(DownloadBookEvent());
                },
                child: Text(AppLocalizations.of(context).download),
              ),
            )
          ],
        ),
      ),
    );
  }
}
