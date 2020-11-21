import 'dart:math';

import 'package:flutter/material.dart';

class QuranByJuzPage extends StatefulWidget {
  @override
  _QuranByJuzPageState createState() => _QuranByJuzPageState();
}

class _QuranByJuzPageState extends State<QuranByJuzPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            dense: true,
            onTap: () {},
            leading: Text("﴿${index + 1}﴾",
                style: TextStyle(
                  fontFamily: 'AlQalamQuranMajeed',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,


                )
            ),
            title: Text("الجزء ${index + 1}",
                style: TextStyle(
                  fontFamily: 'Al-QuranAlKareem',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,


                )
            ),
            subtitle: Text("عدد السور : ${Random().nextInt(114)} ",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Color(0xff949393),
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.normal,


                )
            ),
          );
        },
        itemCount: 30,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
