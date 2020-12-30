import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/note_database_client.dart';
import 'package:quran/data/local/quran_provider.dart';
import 'package:quran/data/local/tafseer_database_client.dart';
import 'package:quran/data/model/quran.dart';
import 'package:quran/di.dart';
import 'package:quran/home_page.dart';
import 'package:quran/page/surah_details/bloc/readers/readers_bloc.dart';
import 'package:quran/page/surah_details/bloc/tafseer/tafseer_bloc.dart';
import 'package:quran/page/surah_details/surah_player.dart';
import 'package:quran/splash_page.dart';

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

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocTransitionObserver();
  AudioPlayer.logEnabled = true;
  await DependencyProvider.build();
  await DependencyProvider.provide<TafseerDataBaseClient>().initDatabase();
  DependencyProvider.provide<QuranProvider>()
      .load()
      .then((value) => print(value.data.surahs.length));
  var noteDatabase = DependencyProvider.provide<NoteDatabaseClient>();
  await noteDatabase.initDb();

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      builder: (context, widget) {
        return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) => ReadersBloc(DependencyProvider.provide(),
                      DependencyProvider.provide())),
              BlocProvider(
                  create: (context) =>
                      TafseerBloc(DependencyProvider.provide()))
            ],
            child: Directionality(
                textDirection: TextDirection.rtl, child: widget));
      },
      title: 'Flutter Demo',
      darkTheme: ThemeData(
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
      ),
      theme: ThemeData(
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
      ),
      home: HomePage(),
    );
  }
}

class IslamicAppBar extends AppBar {
  IslamicAppBar({
    @required String title,
    @required BuildContext context,
    double height,
    PreferredSizeWidget bottom,
    List<Widget> actions,
  }) : super(
            toolbarHeight: height,
            actions: actions,
            bottom: bottom,
            title: Text(title,
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                    fontFamily: "cairo",
                    fontSize: 18)),
            flexibleSpace: Image.asset(
              'assets/images/appbar_background.png',
              fit: BoxFit.fitWidth,
            ));
}
