import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/common.dart';
import 'package:quran/generated/l10n.dart';
import 'package:quran/home_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

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
              child: isDarkMode(context)
                  ? Image.asset(
                      'assets/images/logo_dark.png',
                      height: 150,
                    )
                  : Image.asset('assets/images/logo_light.png', height: 150)),
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
    );
  }
}
