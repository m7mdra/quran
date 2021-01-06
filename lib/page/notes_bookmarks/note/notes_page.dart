import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quran/data/model/note.dart';
import 'package:quran/di.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common.dart';
import 'bloc/bloc.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage>
    with AutomaticKeepAliveClientMixin {
  NoteBloc _noteBloc;

  @override
  void initState() {
    _noteBloc = NoteBloc(DependencyProvider.provide());

    super.initState();
    _noteBloc.add(LoadNotes());
  }

  @override
  void dispose() {
    _noteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_rounded),
        onPressed: () {
          showBottomSheet(
              context: context,
              builder: (context) =>
                  BlocProvider.value(value: _noteBloc, child: AddNoteWidget()));
        },
      ),
      body: BlocBuilder(
        cubit: _noteBloc,
        builder: (BuildContext context, state) {
          if (state is NoteLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          if (state is NoteEmptyState) {
            return EmptyNotesWidget();
          }
          if (state is NoteLoadedState) {
            var list = state.list;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 16),
              itemBuilder: (context, index) {
                var note = list[index];
                return ListTile(

                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => _detailsDialog(note, context));
                  },
                  tileColor: index % 2 == 0
                      ? isDarkMode(context)
                      ? Colors.black12
                      : Color(0xfffcfcfc)
                      : Colors.transparent,
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    maxLines: 3,
                  ),
                  trailing: Text(
                    timeago.format(note.dateTime, clock: DateTime.now()),
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption,
                  ),
                  isThreeLine:
                  true
                  ,
                );
              },
              itemCount: list.length,

            );
          }
          return Container();
        },
      ),
    );
  }

  Dialog _detailsDialog(Note note, BuildContext context) {
    return Dialog(
      child: ListView(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        children: [
          Text(
            note.title,
            style: Theme
                .of(context)
                .textTheme
                .headline6,
          ),
          Text(
            timeago.format(note.dateTime, clock: DateTime.now()),
            style: Theme
                .of(context)
                .textTheme
                .caption,
          ),
          Text(note.content)
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

enum OpenMode { add, update }

class AddNoteWidget extends StatefulWidget {
  final OpenMode mode;

  const AddNoteWidget({Key key, this.mode = OpenMode.add}) : super(key: key);

  @override
  _AddNoteWidgetState createState() => _AddNoteWidgetState();
}

class _AddNoteWidgetState extends State<AddNoteWidget> {
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _contentTextEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleTextEditingController.dispose();
    _contentTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      color: Theme
          .of(context)
          .dialogBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text("اضافة ملاحظة",
                  style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal)),
              SizedBox(height: 16),
              Text('عنوان الملاحظة'),
              TextFormField(
                  controller: _titleTextEditingController,
                  validator: (title) {
                    if (title.isEmpty)
                      return "العنوان خالي";
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), isDense: true)),
              SizedBox(height: 8),
              Text('تفاصيل الملاحظة'),
              TextFormField(
                  controller: _contentTextEditingController,
                  validator: (title) {
                    if (title.isEmpty)
                      return "حقل التفاصيل خالي";
                    else
                      return null;
                  },
                  minLines: 4,
                  maxLines: 10,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), isDense: true)),
              Row(
                children: [
                  Expanded(
                      child: RaisedButton(
                          elevation: 0,
                          hoverElevation: 0,
                          highlightElevation: 0,
                          focusElevation: 0,
                          disabledElevation: 0,
                          color: Theme
                              .of(context)
                              .primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              var title = _titleTextEditingController.text;
                              var content = _contentTextEditingController.text;

                              context
                                  .bloc<NoteBloc>()
                                  .add(AddNewNote(Note(title, content)));
                              _titleTextEditingController.clear();
                              _contentTextEditingController.clear();
                              Navigator.pop(context);
                            }
                          },
                          child: Text('حفظ')),
                      flex: 2),
                  SizedBox(width: 8),
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
                          child: Text('الفاء'))),
                ],
              )
            ],
          ),
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
