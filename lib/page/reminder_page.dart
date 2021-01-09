import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran/islamic_app_bar.dart';
import 'package:quran/page/add_reminder_page.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddReminderPage()));
        },
        child: Icon(Icons.add),
      ),
      appBar: IslamicAppBar(
        title: 'التنبيهات',
        context: context,
      ),
    );
  }
}
