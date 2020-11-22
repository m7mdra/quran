import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/common.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    var itemCount = 10;
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: itemCount == 0
          ? EmptyBookmarksWidget()
          : Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(top: 90),
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: index % 2 == 0
                          ? isDarkMode(context)
                              ? Colors.black12
                              : Color(0xfffcfcfc)
                          : Colors.transparent,
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: CircleAvatar(
                              backgroundColor: Color(0xff9cbd17)
                                  .withAlpha((255 / 0.19).round()),
                              child: Text("1",
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          VerticalDivider()
                        ],
                      ),
                      title: Text("الورد اليومي",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          )),
                      subtitle: Text("صفحة رقم : 255",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.normal,
                          )),
                    );
                  },
                  itemCount: itemCount,
                ),
                Card(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ابحث عن العلامات هنا',
                        prefixIcon: Icon(Icons.search),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                )
              ],
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class EmptyBookmarksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset('assets/images/empty_bookmarks.svg'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("لا توجد علامات حفظ حتي الأن",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 32, right: 32),
            child: new Text(
              "كما يمكنك إضافة أكثر من علامة حفظ علي صفحات السور",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
