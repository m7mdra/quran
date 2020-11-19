import 'package:flutter/material.dart';
import 'package:quran/main.dart';

class SurasPage extends StatefulWidget {
  @override
  _SurasPageState createState() => _SurasPageState();
}

class _SurasPageState extends State<SurasPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'سور القران ',
        bottom: TabBar(
indicatorWeight:5,
          labelColor: Colors.white,
          unselectedLabelStyle: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xffffffff),
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          labelStyle: const TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
              fontFamily: "Cairo",
              fontStyle: FontStyle.normal,
              fontSize: 20.0),
          tabs: [
            Tab(
              text: 'السور',
            ),
            Tab(
              text: 'الاجزاء',
            )
          ],
          controller: TabController(length: 2, vsync: this),
        ),
      ),
    );
  }
}
