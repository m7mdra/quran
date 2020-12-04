import 'dart:math';

import 'package:flutter/material.dart';

class SurahByNumberPage extends StatefulWidget {
  @override
  _SurahByNumberPageState createState() => _SurahByNumberPageState();
}

class _SurahByNumberPageState extends State<SurahByNumberPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          return IndexedSurahWidget(index: index + 1);
        },
        itemCount: 114,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class IndexedSurahWidget extends StatefulWidget {
  final int index;

  const IndexedSurahWidget({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  _IndexedSurahWidgetState createState() => _IndexedSurahWidgetState();
}

class _IndexedSurahWidgetState extends State<IndexedSurahWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () {},
      leading: Text("﴿${widget.index}﴾",
          style: TextStyle(
            fontFamily: 'Al-QuranAlKareem',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          )),
      title: Text("آل عمران",
          style: TextStyle(
            fontFamily: 'alquran',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          )),
      subtitle: Text("عدد الأيات : ${Random().nextInt(300)} ",
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xff949393),
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
