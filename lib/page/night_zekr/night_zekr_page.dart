import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/model/zekr.dart';
import 'package:quran/main.dart';
import 'package:quran/page/night_zekr/bloc/bloc.dart';

import '../../di.dart';
import '../../islamic_app_bar.dart';
import 'bloc/zekr_event.dart';

class NightZekrPage extends StatefulWidget {
  @override
  _NightZekrPageState createState() => _NightZekrPageState();
}

class _NightZekrPageState extends State<NightZekrPage> {
  ZekrBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ZekrBloc(DependencyProvider.provide());
    _bloc.add(LoadNightZekr());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(title: 'اذكار المساء', context: context),
      body: BlocBuilder(
        cubit: _bloc,
        builder: (BuildContext context, state) {
          if (state is ZekrLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ZekrLoadedState) {
            var zekr = state.list;
            return ListView.builder(
              itemBuilder: (context, index) {
                var item = zekr[index];

                return ZekrWidget(
                  item: item,
                  indexInList: index,
                );
              },
              itemCount: zekr.length,
            );
          } else
            return Container();
        },
      ),
    );
  }
}

class ZekrWidget extends StatelessWidget {
  final Content item;
  final int indexInList;

  const ZekrWidget({
    Key key,
    @required this.item,
    this.indexInList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Card(
            margin:
                const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تكرار ${item.repeat}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(item.zekr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      )),
                  if (item.bless.isNotEmpty)
                    Text('${item.bless}\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment(-0.96, 0),
          child: Container(
              width: 50,
              height: 50,
              child: Text("${indexInList + 1}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xfffd9f00),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.normal,
                  )),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  color: const Color(0xffffecbf))),
        )
      ],
    );
  }
}
