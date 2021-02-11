import 'package:flutter/material.dart';
import 'package:quran/widget/islamic_app_bar.dart';

class AddReminderPage extends StatefulWidget {
  @override
  _AddReminderPageState createState() => _AddReminderPageState();
}

class _AddReminderPageState extends State<AddReminderPage> {
  DateTime selectedDate;
  TimeOfDay selectedTime;
  GlobalKey<FormState> _globalKey = GlobalKey();
  TextEditingController _nameEditingController = TextEditingController();
  TextEditingController _dateEditingController = TextEditingController();
  TextEditingController _timeEditingController = TextEditingController();
  var inputDecoration = InputDecoration(
      border: OutlineInputBorder(),
      isDense: true,
      contentPadding: const EdgeInsets.all(8));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        context: context,
        title: 'اضافة المنبه',
      ),
      body: Form(
        key: _globalKey,
        child: ListView(
          children: [
            Text('اسم المنبه'),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) return 'حقل الاسم لا يمكن ان يكون خالي';
                return null;
              },
              controller: _nameEditingController,
              decoration: inputDecoration,
            ),
            Text('التاريخ'),
            TextFormField(
              readOnly: true,
              controller: _dateEditingController,
              decoration: inputDecoration.copyWith(
                  suffixIcon: IconButton(
                      icon: _buildIcon(context, Icons.calendar_today),
                      onPressed: () async {
                        showDatePickDialog();
                      })),
            ),
            Text('الوقت'),
            TextFormField(
              validator: (value) {
                Duration diff = difference();
                if (diff.isNegative) {
                  return 'لا يمكنك اضافة منبه في الزمن الماضي';
                } else
                  return null;
              },
              readOnly: true,
              controller: _timeEditingController,
              enabled: selectedDate != null,
              decoration: inputDecoration.copyWith(
                  suffixIcon: IconButton(
                      icon: _buildIcon(context, Icons.access_time),
                      onPressed: () {
                        showTimePickerDialog();
                      })),
            ),
            SizedBox(height: 16),
            RaisedButton(
              child: Text(
                'Save',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
              onPressed: selectedDate != null && selectedTime != null
                  ? () async {
                      /*      if (_globalKey.currentState.validate()) {
                  var id = Random().nextInt(1000000);
                  print("register task with id: $id");
                  await Workmanager.registerOneOffTask(
                      "reminder$id", "reminder$id",
                      inputData: {'id': id}, initialDelay: difference());
                  var client = DependencyProvider.provide<QuranDatabaseClient>();
                  client.addReminder(Reminder(id, _nameEditingController.text));
                }*/
                    }
                  : null,
              elevation: 0,
              hoverElevation: 0,
              highlightElevation: 0,
              disabledElevation: 0,
              focusElevation: 0,
            )
          ],
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Duration difference() {
    var dateTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);
    var difference = dateTime.difference(DateTime.now());
    return difference;
  }

  Container _buildIcon(BuildContext context, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Center(child: Icon(icon)),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(100),
          borderRadius: BorderRadius.circular(8)),
    );
  }

  void showDatePickDialog() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 5));
    if (date != null) {
      setState(() {
        this.selectedDate = date;
      });
      showTimePickerDialog();
      _dateEditingController.text =
          "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}";
    }
  }

  void showTimePickerDialog() async {
    var time = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 5))));
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
      _timeEditingController.text = selectedTime.format(context);
    }
  }
}
/*
*
*   var date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 5));
          if (date != null) {
            var nowTime = TimeOfDay.now();
            var time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(
                    DateTime.now().add(Duration(minutes: 1))));
            if (time != null) {
              var dateTime = DateTime(
                  date.year, date.month, date.day, time.hour, time.minute);
              var difference = dateTime.difference(DateTime.now());
              print(difference);
              if (difference.isNegative) {
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text('Selected time is negative.')));
              } else {
                Workmanager.registerOneOffTask("uniqueName", "taskName",
                    initialDelay: difference);
              }
            }
          }
* */
