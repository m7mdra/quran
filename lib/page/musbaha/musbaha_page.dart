import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/di.dart';
import 'package:quran/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterCubit extends Cubit<int> {
  final SharedPreferences _sharedPreferences;

  CounterCubit(this._sharedPreferences)
      : super(_sharedPreferences.getInt("count") ?? 0);

  Future<void> increment() async {
    await _sharedPreferences.setInt("count", state + 1);
    emit(state + 1);
  }

  /// Subtract 1 from the current state.
  Future<void> zero() async {
    await _sharedPreferences.setInt("count", 0);

    emit(0);
  }
}

class MusbahaPage extends StatefulWidget {
  @override
  _MusbahaPageState createState() => _MusbahaPageState();
}

class _MusbahaPageState extends State<MusbahaPage> {
  int value = 0;
  CounterCubit _counterCubit;

  @override
  void initState() {
    super.initState();
    _counterCubit = CounterCubit(DependencyProvider.provide());
  }

  @override
  void dispose() {
    super.dispose();
    _counterCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        context: context,
        title: 'المسبحة',
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<CounterCubit, int>(
                builder: (BuildContext context, state) {
                  return Text.rich(TextSpan(
                      text: '$state',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            text: ' مرة ',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600))
                      ]));
                },
                cubit: _counterCubit,
              ),
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      elevation: 0,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      focusElevation: 0,

                      onPressed: () async {
                        await _counterCubit.increment();
                      },
                      child: Text(
                        'تسبيح',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _showMaterialDialog();
                    },
                    child: Text('تصفير العداد', style: TextStyle(fontSize: 16)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'تنبيه',
              textAlign: TextAlign.right,
            ),
            content: Text(
              'هل تريد الرجوع إلي الصفر؟',
              textAlign: TextAlign.right,
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('إلغاء')),
              FlatButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _counterCubit.zero();
                },
                child: Text('نعم'),
              )
            ],
          );
        });
  }
}
