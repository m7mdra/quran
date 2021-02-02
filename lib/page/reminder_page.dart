import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quran/data/local/quran_meta_database.dart';
import 'package:quran/data/model/reminder.dart';
import 'package:quran/di.dart';
import 'package:quran/islamic_app_bar.dart';

import 'add_reminder_page.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  var quranDbClient = DependencyProvider.provide<QuranMetaDatabase>();

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
      body: FutureBuilder(
        builder:
            (BuildContext context, AsyncSnapshot<List<Reminder>> snapshot) {
          var list = snapshot.data;
          if (!snapshot.hasData)
            return Container();
          else
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    quranDbClient.completeReminder(list[index].id);
                    setState(() {});
                  },
                  title: Text(list[index].name),
                  trailing: Text(
                      list[index].isCompleted ? 'completed' : 'not completed'),
                );
              },
              itemCount: list.length,
            );
        },
        future: quranDbClient.getReminders(),
      ),
      appBar: IslamicAppBar(
        title: 'التنبيهات',
        context: context,
      ),
    );
  }
}
