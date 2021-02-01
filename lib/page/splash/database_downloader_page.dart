import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/di.dart';
import 'package:quran/page/riyadh/bloc/bloc.dart';
import 'package:quran/page/splash/bloc/bloc.dart';

import '../../common.dart';
import 'bloc/database_download_bloc.dart';

class DatabaseDownloadPage extends StatefulWidget {
  @override
  _DatabaseDownloadPagerState createState() => _DatabaseDownloadPagerState();
}

class _DatabaseDownloadPagerState extends State<DatabaseDownloadPage> {
  DownloadDatabaseBloc _databaseBloc;
  ProgressCubit _progressCubit;

  @override
  void initState() {
    super.initState();
/*    _progressCubit = context.bloc();

    _databaseBloc = context.bloc();*/
    _progressCubit = ProgressCubit(0);
    _databaseBloc = DownloadDatabaseBloc(
        DependencyProvider.provide(),
        DependencyProvider.provide(),
        _progressCubit,
        DependencyProvider.provide());
    _databaseBloc.add(CheckDatabaseExistence());
  }

  @override
  void dispose() {
    _progressCubit.close();
    _databaseBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: BlocBuilder(
            cubit: _databaseBloc,
            builder: (context, state) {
              print(state);
              if (state is DownloadDatabaseNotFoundState) {
                return DatabaseNotFound(databaseBloc: _databaseBloc);
              }
              if (state is ProcessingDatabaseLoadingState) {
                return Column(
                  children: [
                    QuranImageWidget(),
                    size(),
                    Text(
                      'يتم الان معالجة البيانات التشغيلية',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    size16(),
                    BlocBuilder(
                      builder: (context, state) {
                        return Column(
                          children: [
                            size(),
                            LinearProgressIndicator(value: null),
                            size(),
                            Text('قد تاخد هذه العملية زمنا طويلاً...')
                          ],
                        );
                      },
                      cubit: _progressCubit,
                    ),
                  ],
                );
              }
              if (state is DownloadDatabaseSuccessState) {
                return Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 150),
                    size16(),
                    Text('تم تحميل ومعالجة البيانات بنجاح',
                        style: Theme.of(context).textTheme.headline6),
                    size(),
                    Text(
                        'يمكنك الان ان تبدا باستخدام التطبيق بكل خواصه المتاحة',
                        textAlign: TextAlign.center),
                    size16(),
                    RaisedButton(
                        onPressed: () {},
                        child: Text('حسنا , ابدا استخدام التطبيق'),
                        elevation: 0,
                        color: Theme.of(context).primaryColor,
                        disabledElevation: 0,
                        textColor: Colors.white,
                        focusElevation: 0,
                        highlightElevation: 0,
                        hoverElevation: 0)
                  ],
                );
              }
              if (state is DatabaseDownloadingState) {
                return Column(
                  children: [
                    QuranImageWidget(),
                    size(),
                    Text(
                      'يتم الان تحميل البيانات التشغيلية',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    size16(),
                    BlocBuilder(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text('تم تحميل ${state.toDouble()}% '),
                            size(),
                            LinearProgressIndicator(
                                value: state != 100 || state == 0
                                    ? state * 0.01
                                    : null),
                          ],
                        );
                      },
                      cubit: _progressCubit,
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  SizedBox size16() => SizedBox(height: 16);

  SizedBox size() => SizedBox(height: 8);
}

class QuranImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return isDarkMode(context)
        ? Image.asset(
            'assets/images/logo_dark.png',
            height: 120,
          )
        : Image.asset('assets/images/logo_light.png', height: 120);
  }
}

class DatabaseNotFound extends StatelessWidget {
  const DatabaseNotFound({
    Key key,
    @required DownloadDatabaseBloc databaseBloc,
  })  : _databaseBloc = databaseBloc,
        super(key: key);

  final DownloadDatabaseBloc _databaseBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(children: [
        QuranImageWidget(),
        SizedBox(height: 8),
        Text(
          'مرحبا بكم في تطبيق القران',
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(height: 8),
        Text(
          'على ما يبدو هذه المرة الاولى لك باستخدام التطبيق,'
          ' سوف يقوم التطبيق بتحميل بيانات حجمها ٧٠ ميجا عبر الانترنت الخاص بك ,'
          ' هذه البيانات مهمة جدا لاستخدام جميع خواص التطبيق ولا يمكن للتطبيق العمل بدونها.',
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        RaisedButton(
            onPressed: () {
              _databaseBloc.add(StartDownloadDatabaseEvent());
            },
            child: Text('حسنا , ابدا التحميل'),
            elevation: 0,
            color: Theme.of(context).primaryColor,
            disabledElevation: 0,
            textColor: Colors.white,
            focusElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0),
        SizedBox(height: 8),
        RaisedButton(
            onPressed: () {
              //TODO
            },
            child: Text('تحميل لاحقا'),
            color: Theme.of(context).disabledColor,
            elevation: 0,
            textColor: Colors.white,
            disabledElevation: 0,
            focusElevation: 0,
            highlightElevation: 0,
            hoverElevation: 0),
        Text(
          'لا يمكنك استخدام التطبيق في هذه الحالة',
          style: Theme.of(context).textTheme.caption,
        )
      ]),
    );
  }
}
