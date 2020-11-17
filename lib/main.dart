import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

 const MaterialColor swatchAccent = MaterialColor(_swatchAccentValue, <int, Color>{
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
      home: SplashPage(),
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

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/splash_background.svg',
            fit: BoxFit.cover,
          ),
          Align(
            alignment: AlignmentDirectional(0, -0.4),
            child: SvgPicture.asset(
              'assets/images/logo.svg',
              fit: BoxFit.cover,
            ),
          ),
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
                Text("يتم الأن تحميل الصفحات",
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
                Text("Application Sponsor : Wado Tech",
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
    );
  }
}
