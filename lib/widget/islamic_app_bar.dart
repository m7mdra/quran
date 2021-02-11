import 'package:flutter/material.dart';

class IslamicAppBar extends AppBar {
  IslamicAppBar({
    @required String title,
    BuildContext context,
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
