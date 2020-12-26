import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/model/juz_response.dart';
import 'package:quran/di.dart';
import 'package:collection/collection.dart';
import 'bloc/bloc.dart';
import 'bloc/juz_bloc.dart';

class JuzPage extends StatefulWidget {
  @override
  _JuzPageState createState() => _JuzPageState();
}

class _JuzPageState extends State<JuzPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) {
/*          return JuzWidget(
            index: index + 1,
            onTap: (juz) {

            },
          );*/
        return Container();
        },
        itemCount: 30,
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class JuzWidget extends StatefulWidget {
  final int index;
  final Function(Juz) onTap;

  const JuzWidget({
    Key key,
    @required this.index,
    this.onTap,
  }) : super(key: key);

  @override
  _JuzWidgetState createState() => _JuzWidgetState();
}

class _JuzWidgetState extends State<JuzWidget>
    with AutomaticKeepAliveClientMixin {
  JuzBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = JuzBloc(DependencyProvider.provide());
    _bloc.add(LoadJuzListEvent(widget.index));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  Widget get _juzIndexWidget => Text("﴿${widget.index}﴾",
      style: TextStyle(
        fontFamily: 'Al-QuranAlKareem',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
      ));

  Widget _trailingWidgetForState(JuzState state) {
    if (state is JuzsLoadingState) {
      return SizedBox(
        child: CircularProgressIndicator(strokeWidth: 2),
        width: 20,
        height: 20,
      );
    }

    if (state is JuzsErrorState) {
      return FlatButton(
          onPressed: () {
            _bloc.add(LoadJuzListEvent(widget.index));
          },
          child: Text('اعادة المحاولة'));
    }
    return null;
  }

  Widget _subtitleWidgetForState(JuzState state) {
    if (state is JuzsLoadingState) {
      return Text('جاري التحميل');
    }
    if (state is JuzsSuccessState) {
      return Text("عدد السور : ${state.juz.surahs.values.length} ",
          style: TextStyle(
            fontFamily: 'Cairo',
            color: Color(0xff949393),
            fontSize: 14,
            fontWeight: FontWeight.w300,
            fontStyle: FontStyle.normal,
          ));
    }
    if (state is JuzsErrorState) {
      return Text(
        'فشل تحميل البيانات',
        style: TextStyle(inherit: true, color: Theme.of(context).errorColor),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder(
      cubit: _bloc,
      builder: (BuildContext context, state) {
        return ListTile(
          dense: true,
          onTap: state is JuzsSuccessState
              ? () {
                  widget?.onTap(state.juz);
                }
              : null,
          trailing: _trailingWidgetForState(state),
          leading: _juzIndexWidget,
          title: Text("الجزء ${widget.index}",
              style: TextStyle(
                fontFamily: 'alquran',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              )),
          subtitle: _subtitleWidgetForState(state),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
