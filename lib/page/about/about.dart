import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/common.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
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
                      height: 200,
                    )
                  : Image.asset('assets/images/logo_light.png', height: 200)),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                ),
                Text('القران الكريم',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    )),
                Text(AppLocalizations.of(context).applicationSponsor,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    )),
                Text("2020 - 2021",
                    style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontFamily: "Cairo",
                        fontStyle: FontStyle.normal,
                        fontSize: 18.0),
                    textAlign: TextAlign.left),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                        MaterialLocalizations.of(context).backButtonTooltip))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
