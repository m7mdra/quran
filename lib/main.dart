import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData(),
      theme: ThemeData(
        fontFamily: 'cairo',
        primaryColorDark: Color(0xff9cbd17),
        primaryColor: Color(0xff9cbd17),
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
