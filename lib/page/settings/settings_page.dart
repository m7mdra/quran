import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/common.dart';
import 'package:quran/main/bloc/theme/theme_cubit.dart';
import 'package:quran/widget/islamic_app_bar.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(title: "الاعدادات"),
      body: ListView(
        children: [
          ListTile(selected: true,title: Text("شكل التطبيق"),dense: true,),
          SwitchListTile(
              secondary: Icon(Icons.nightlight_round),
              title: Text("الوضع المظلم"),
              value: isDarkMode(context),
              onChanged: (value) {
                var themeCubit = context.bloc<ThemeCubit>();
                if (isDarkMode(context)) {
                  themeCubit.light();
                } else {
                  themeCubit.dark();
                }
              }),
          Divider(),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text("لون الخلفية"),
            trailing: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Divider(),
          ListTile(selected: true,title: Text("قارئ القران"),dense: true,),
          ListTile(title: Text("تفسيير الايات"),subtitle: Text('تفسير الجلالين')),
          ListTile(title: Text("اصدار القران"),subtitle: Text('القران العثماني')),

        ],
      ),
    );
  }
}
