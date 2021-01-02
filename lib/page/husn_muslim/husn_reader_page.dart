import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/model/husn.dart';
import 'package:quran/di.dart';
import 'package:quran/page/husn_muslim/bloc/husn_muslim_chapter/bloc.dart';

import '../../islamic_app_bar.dart';
import '../../main/main.dart';

class HusnReaderPage extends StatefulWidget {
  final List<Chapter> chapters;
  final int position;

  const HusnReaderPage({Key key, this.chapters, this.position})
      : super(key: key);

  @override
  _HusnReaderPageState createState() => _HusnReaderPageState();
}

class _HusnReaderPageState extends State<HusnReaderPage> {
  final _pageController = PageController();
  var _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.position;
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      _pageController.animateToPage(widget.position,
          duration: Duration(milliseconds: 10), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(title: 'حصن المسلم', context: context),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              pageSnapping: true,
              controller: _pageController,
              itemBuilder: (context, index) {
                return HusnChapterWidget(
                  index: index,
                  chapter: widget.chapters[index],
                );
              },
              itemCount: widget.chapters.length,
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 0,
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChangePageButton(
                    icon: Icons.arrow_back_ios,
                    onTap: () {
                      if (isFirstPage())
                        return _pageController.animateToPage(_currentPage - 1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                    },
                    enabled: isFirstPage(),
                  ),
                  Text("${widget.chapters.length} / ${_currentPage + 1}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                      )),
                  ChangePageButton(
                    icon: Icons.arrow_forward_ios,
                    onTap: () {
                      if (isLastPage())
                        return _pageController.animateToPage(_currentPage + 1,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear);
                    },
                    enabled: isLastPage(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  bool isFirstPage() => _currentPage != 0;

  bool isLastPage() => _currentPage != widget.chapters.length - 1;
}

class HusnChapterWidget extends StatefulWidget {
  final int index;
  final Chapter chapter;

  const HusnChapterWidget({Key key, this.index, this.chapter})
      : super(key: key);

  @override
  _HusnChapterWidgetState createState() => _HusnChapterWidgetState();
}

class _HusnChapterWidgetState extends State<HusnChapterWidget> {
  HusnChapterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = HusnChapterBloc(DependencyProvider.provide());
    _bloc.add(LoadHusnChapterData(widget.index + 1));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _bloc,
      builder: (BuildContext context, state) {
        if (state is HusnChapterLoadingState) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HusnChapterLoadedState) {
          return Column(
            children: [
              Text(
                widget.chapter.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                ),
              ),
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int index) {
                    var data = state.chapter.list[index];
                    return Text(data.arabicText,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: 'Alquran',
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                        ));
                  },
                  itemCount: state.chapter.list.length,
                ),
              ),
            ],
          );
        } else {
          return Text('فشل تحميل البيانات');
        }
      },
    );
  }
}

class ChangePageButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool enabled;
  final IconData icon;

  const ChangePageButton({Key key, this.onTap, this.enabled, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: enabled ? onTap : null,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff9cbd17).withAlpha(255 ~/ 0.3)),
          child: Icon(
            icon,
            color: Theme.of(context).accentColor,
          ),
        ));
  }
}
