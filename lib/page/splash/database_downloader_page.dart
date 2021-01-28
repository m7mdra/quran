import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _progressCubit = context.bloc();
    _progressCubit.listen((state) {
      print("progress: $state");
    });
    _databaseBloc = context.bloc();
    _databaseBloc.listen((state) {
      print("state: $state");
    });
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
        child: BlocBuilder(
          cubit: _databaseBloc,
          builder: (context, state) {
            if (state is DownloadDatabaseNotFoundState) {
              return DatabaseNotFound(databaseBloc: _databaseBloc);
            }
            if (state is DatabaseDownloadingState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DownloadHeader(),
                    SizedBox(height: 8),
                    Text(
                      'يتم الان تحميل البيانات التشغيلية',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(height: 16),
                    BlocBuilder(
                      builder: (context, state) {
                        return Column(
                          children: [
                            Text(state != 100? 'تم تحميل ${state.toDouble()}% ':'جاري معالجة البيانات'),
                            SizedBox(height: 8),
                            LinearProgressIndicator(
                                value: state != 100 ? state * 0.01 : null),
                          ],
                        );
                      },
                      cubit: _progressCubit,
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class DownloadHeader extends StatelessWidget {
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
        DownloadHeader(),
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
