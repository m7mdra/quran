import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/common.dart';
import 'package:quran/di.dart';
import 'package:quran/page/riyadh/bloc/riyadh_book_bloc.dart';
import 'package:quran/page/splash/bloc/bloc.dart';
import 'package:quran/page/splash/database_downloader_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  DownloadDatabaseBloc _databaseBloc;
  ProgressCubit _progressCubit;

  @override
  void initState() {
    super.initState();
    _progressCubit = ProgressCubit(0);
    _databaseBloc = DownloadDatabaseBloc(
        DependencyProvider.provide(),
        DependencyProvider.provide(),
        _progressCubit,
        DependencyProvider.provide());
    _databaseBloc.add(CheckDatabaseExistence());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        cubit: _databaseBloc,
        listener: (context, state) {
          if (state is DownloadDatabaseNotFoundState) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(providers: [
                          BlocProvider(create: (context) => _databaseBloc),
                          BlocProvider(create: (context) => _progressCubit),
                        ], child: DatabaseDownloadPage())));
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/splash_background.svg',
              fit: BoxFit.cover,
            ),
            Align(
                alignment: AlignmentDirectional(0, -0.4),
                child: isDarkMode(context)
                    ? Image.asset(
                        'assets/images/logo_dark.png',
                        height: 200,
                      )
                    : Image.asset('assets/images/logo_light.png', height: 200)),
            Align(
              alignment: AlignmentDirectional(0, 0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoActivityIndicator(
                    radius: 15,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(AppLocalizations.of(context).splashLoadingTitle,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff4e4e4e),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal,
                      ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 80,
                  ),
                  Text(AppLocalizations.of(context).applicationSponsor,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Color(0xff605959),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )),
                  Text("2020 - 2021",
                      style: const TextStyle(
                          color: const Color(0xff605959),
                          fontWeight: FontWeight.w300,
                          fontFamily: "Cairo",
                          fontStyle: FontStyle.normal,
                          fontSize: 16.0),
                      textAlign: TextAlign.left)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
