import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SurahTitleWidget extends StatelessWidget {
  final String surah;

  const SurahTitleWidget({Key key, this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/surah_name_title.svg',
          ),
          Text(
            surah,
            style: TextStyle(
              color: Color(0xffFD9434),
              fontSize: 24,
              fontFamily: 'quran',
            ),
          )
        ],
      ),
    );
  }
}
