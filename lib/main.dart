import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/note_database_client.dart';
import 'package:quran/data/local/quran_provider.dart';
import 'package:quran/data/local/tafseer_database_client.dart';
import 'package:quran/di.dart';
import 'package:quran/home_page.dart';
import 'package:quran/main/bloc/theme/theme_cubit.dart';
import 'package:quran/page/juz_surah/surahs/bloc/surahs_bloc.dart';
import 'package:quran/page/surah_details/bloc/reader/quran_reader_bloc.dart';
import 'package:quran/page/surah_details/bloc/readers/readers_bloc.dart';
import 'package:quran/page/surah_details/bloc/tafseer/tafseer_bloc.dart';
import 'package:workmanager/workmanager.dart';

import 'main/bloc_observer.dart';

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) {
    print(task);
    print(inputData);
    return Future.value(true);
  });
}

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocTransitionObserver();
  AudioPlayer.logEnabled = true;
  await DependencyProvider.build();
  await DependencyProvider.provide<TafseerDataBaseClient>().initDatabase();
  DependencyProvider.provide<QuranProvider>()
      .load()
      .then((value) => print(value.data.surahs.length));
  var noteDatabase = DependencyProvider.provide<QuranDatabaseClient>();
  await noteDatabase.initDb();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);

  runApp(MyApp());
}

const MaterialColor _swatch = MaterialColor(_swatchPrimaryValue, <int, Color>{
  50: Color(0xFFF3F7E3),
  100: Color(0xFFE1EBB9),
  200: Color(0xFFCEDE8B),
  300: Color(0xFFBAD15D),
  400: Color(0xFFABC73A),
  500: Color(_swatchPrimaryValue),
  600: Color(0xFF94B714),
  700: Color(0xFF8AAE11),
  800: Color(0xFF80A60D),
  900: Color(0xFF6E9807),
});
const int _swatchPrimaryValue = 0xFF9CBD17;

const MaterialColor swatchAccent =
    MaterialColor(_swatchAccentValue, <int, Color>{
  100: Color(0xFFECFFC5),
  200: Color(_swatchAccentValue),
  400: Color(0xFFCBFF5F),
  700: Color(0xFFC3FF46),
});
const int _swatchAccentValue = 0xFFDCFF92;
var darkTheme = ThemeData(
  fontFamily: 'Cairo',
  primarySwatch: _swatch,
  accentColor: Color(_swatchAccentValue),
  primaryColor: Color(_swatchPrimaryValue),
  backgroundColor: Color(0xff373636),
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData().copyWith(color: Colors.white)),
);
var theme = ThemeData(
  fontFamily: 'Cairo',
  brightness: Brightness.light,
  primarySwatch: _swatch,
  accentColor: Color(_swatchAccentValue),
  primaryColor: Color(_swatchPrimaryValue),
  backgroundColor: Color(0xFFFCFCFC),
  appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData().copyWith(color: Colors.white)),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeCubit _themeCubit;

  @override
  void initState() {
    _themeCubit = ThemeCubit(DependencyProvider.provide());
    super.initState();
  }

  @override
  void dispose() {
    _themeCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _themeCubit,
      builder: (BuildContext context, state) {
        return MaterialApp(
          themeMode: _modeFromState(state),
          builder: (context, widget) {
            return MultiBlocProvider(
                providers: [
                  BlocProvider(create: (context) => _themeCubit),
                  BlocProvider(
                      create: (context) =>
                          SurahsBloc(DependencyProvider.provide())),
                  BlocProvider(
                      create: (context) =>
                          QuranReaderBloc(DependencyProvider.provide())),
                  BlocProvider(
                      create: (context) => ReadersBloc(
                          DependencyProvider.provide(),
                          DependencyProvider.provide())),
                  BlocProvider(
                      create: (context) =>
                          TafseerBloc(DependencyProvider.provide())),
                ],
                child: Directionality(
                    textDirection: TextDirection.rtl, child: widget));
          },
          title: 'Flutter Demo',
          darkTheme: darkTheme,
          theme: theme,
          home: HomePage(),
        );
      },
    );
  }

  ThemeMode _modeFromState(ThemeState state) {
    if (state.theme == 1)
      return ThemeMode.light;
    else if (state.theme == 2)
      return ThemeMode.dark;
    else
      return ThemeMode.system;
  }
}
