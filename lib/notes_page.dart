import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
              context: context, builder: (context) => AddNoteWidget());
        },
      ),
      body: EmptyNotesWidget(),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AddNoteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      color: Theme.of(context).dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text("اضافة ملاحظة",
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
            SizedBox(height: 16),
            Text('عنوان الملاحظة'),
            TextField(
              decoration:
                  InputDecoration(border: OutlineInputBorder(), isDense: true),
            ),
            SizedBox(height: 8),
            Text('تفاصيل الملاحظة'),
            TextField(
              minLines: 4,
              maxLines: 10,
              decoration:
                  InputDecoration(border: OutlineInputBorder(), isDense: true),
            ),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    elevation: 0,
                    hoverElevation: 0,
                    highlightElevation: 0,
                    focusElevation: 0,
                    disabledElevation: 0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {},
                    child: Text('حفظ'),
                  ),
                  flex: 2,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: RaisedButton(
                  elevation: 0,
                  hoverElevation: 0,
                  highlightElevation: 0,
                  focusElevation: 0,
                  disabledElevation: 0,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('الفاء'),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EmptyNotesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/images/note.svg",
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 16,
          ),
          Text("لا توجد ملاحظات حتي الأن ",
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
              )),
          Text(
              "قم باضافة ملاحظة بالضغط على الزر الدائري بعلامة الزائد في الاسفل",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.normal,
              ))
        ],
      ),
    );
  }
}
