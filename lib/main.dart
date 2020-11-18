import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/home_page.dart';
import 'package:quran/splash_page.dart';

void main() {
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
      builder: (context, widget) {
        return Directionality(textDirection: TextDirection.rtl, child: widget);
      },
      title: 'Flutter Demo',
      darkTheme: ThemeData(),
      theme: ThemeData(
        fontFamily: 'cairo',
        primarySwatch: _swatch,
        primaryColor: Color(_swatchPrimaryValue),
        backgroundColor: Color(0xFFFCFCFC),
        appBarTheme: AppBarTheme(centerTitle: true, elevation: 0),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class IslamicAppBar extends AppBar {
  IslamicAppBar({
    String title,
    PreferredSizeWidget bottom,
    List<Widget> actions,
  }) : super(
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
