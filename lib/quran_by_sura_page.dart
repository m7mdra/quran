import 'dart:math';

import 'package:flutter/material.dart';

class QuranBySuraPage extends StatefulWidget {
  @override
  _QuranBySuraPageState createState() => _QuranBySuraPageState();
}

class _QuranBySuraPageState extends State<QuranBySuraPage>
    with AutomaticKeepAliveClientMixin {
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
                  fontFamily: 'Al-QuranAlKareem',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,


                )
            ),
            title: Text("آل عمران",
                style: TextStyle(
                  fontFamily: 'alquran',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal,


                )
            ),
            subtitle: Text("عدد الأيات : ${Random().nextInt(300)} ",
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
        itemCount: 114,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
