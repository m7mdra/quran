import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart' as l10n;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:quran/data/local/preference.dart';
import 'package:quran/data/local/quran_database.dart';
import 'package:quran/data/local/quran_meta_database.dart';
import 'package:quran/di.dart';
import 'package:quran/main/bloc/lang/language_cubit.dart';
import 'package:quran/main/bloc/theme/theme_cubit.dart';
import 'package:quran/page/juz_surah/surahs/bloc/surahs_bloc.dart';
import 'package:quran/page/quran_reader/bloc/reader/last_read_bloc.dart';
import 'package:quran/page/quran_reader/bloc/readers/readers_bloc.dart';
import 'package:quran/page/quran_reader/bloc/tafseer/tafseer_bloc.dart';
import 'package:quran/page/splash/splash_page.dart';
import 'package:quran/theme.dart';

import 'main/bloc_observer.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocTransitionObserver();
  AudioPlayer.logEnabled = true;
  await DependencyProvider.build();
  if (DependencyProvider.provide<Preference>()
      .didExtractDatabaseDownloadSuccess()) {
    var quranDatabase = DependencyProvider.provide<QuranDatabase>();
    await quranDatabase.initDb();
    quranDatabase.juz().then((value) {
      print(value);
    }).catchError((error, stack) {
      print(error);
      print(stack);
    });
  }

  var noteDatabase = DependencyProvider.provide<QuranMetaDatabase>();
  await noteDatabase.initDb();
  LanguageCubit cubit = LanguageCubit(DependencyProvider.provide());
  cubit.load();
  runApp(BlocProvider.value(value: cubit, child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeCubit _themeCubit;
  LanguageCubit _languageCubit;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white54));
    _languageCubit = context.bloc();
    _themeCubit = ThemeCubit(DependencyProvider.provide());
  }

  @override
  void dispose() {
    _themeCubit.close();
    _languageCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext appContext) {
    return BlocBuilder(
      cubit: _languageCubit,
      builder: (BuildContext context, langState) {
        return BlocBuilder(
          cubit: _themeCubit,
          builder: (BuildContext context, themeState) {
            return MaterialApp(
              localizationsDelegates: [
                l10n.AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              localeListResolutionCallback: (locales, supportedLocales) {
                for (Locale locale in locales) {
                  // if device language is supported by the app,
                  // just return it to set it as current app language
                  if (supportedLocales.contains(locale)) {
                    return locale;
                  }
                }

                // if device language is not supported by the app,
                // the app will set it to english but return this to set to Bahasa instead
                return Locale('ar');
              },
              supportedLocales: [
                const Locale('en'),
                const Locale('ar'),
              ],
              locale: _languageForState(langState),
              themeMode: _modeFromState(themeState),
              builder: (context, widget) {
                return MultiBlocProvider(providers: [
                  BlocProvider(create: (context) => _themeCubit),
                  BlocProvider(create: (context) => _languageCubit),
                  BlocProvider(
                      create: (context) =>
                          SurahsBloc(DependencyProvider.provide())),
                  BlocProvider(
                      create: (context) =>
                          LastReadBloc(DependencyProvider.provide())),
                  BlocProvider(
                      create: (context) => ReadersBloc(
                          DependencyProvider.provide(),
                          DependencyProvider.provide())),
                  BlocProvider(
                      create: (context) =>
                          LastReadBloc(DependencyProvider.provide())),
                  BlocProvider(
                      create: (context) =>
                          TafseerBloc(DependencyProvider.provide())),
                ], child: widget);
              },
              title: 'Flutter Demo',
              darkTheme: darkTheme,
              theme: theme,
              home: SplashPage(),
            );
          },
        );
      },
    );
  }

  Locale _languageForState(LanguageState state) {
    var savedLanguage = state.language;
    if (savedLanguage != null)
      return Locale(savedLanguage);
    else
      return Locale('ar');
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
