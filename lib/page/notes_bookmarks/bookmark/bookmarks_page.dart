import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/di.dart';
import 'package:quran/page/notes_bookmarks/bookmark/bloc/get_bookmarks_cubit.dart';

import 'bookmark_widget.dart';
import 'empty_bookmarks_widget.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage>
    with AutomaticKeepAliveClientMixin {
  GetBookmarkCubit _getBookmarkCubit;

  @override
  void initState() {
    _getBookmarkCubit = GetBookmarkCubit(DependencyProvider.provide());
    super.initState();
    _getBookmarkCubit.loadBookmarks();
  }

  @override
  void dispose() {
    _getBookmarkCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder(
        cubit: _getBookmarkCubit,
        builder: (BuildContext context, state) {
          if (state is GetBookmarksLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GetBookmarksEmpty) {
            return EmptyBookmarksWidget();
          }
          if (state is GetBookmarksError) {
            return Center(
              child: Text('فشل تحميل عناصر القائمة'),
            );
          }
          if (state is GetBookmarksSuccess) {
            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(top: 90),
                  itemBuilder: (context, index) {
                    var bookmark = state.list[index];
                    return BookmarkWidget(
                      bookmark: bookmark,
                      index: index,
                    );
                  },
                  itemCount: state.list.length,
                ),
                Card(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ابحث عن العلامات هنا',
                        prefixIcon: Icon(Icons.search),
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
