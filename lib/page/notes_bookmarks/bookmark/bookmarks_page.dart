import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran/data/local/quran_provider.dart';
import 'package:quran/di.dart';
import 'package:quran/page/notes_bookmarks/bookmark/bloc/get_bookmarks_cubit.dart';
import 'package:quran/page/surah_details/surah_details.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    _getBookmarkCubit = GetBookmarkCubit(
        DependencyProvider.provide(), DependencyProvider.provide());
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
              child: Text(AppLocalizations.of(context).failedToLoadData),
            );
          }
          if (state is GetBookmarksSuccess) {
            return Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (context, index) {
                    var bookmark = state.list[index];
                    return BookmarkWidget(
                      onTap: (bookmark) async {

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) {
                                  var surah = bookmark.getSurah;
                                  return SurahDetails(
                                      surah: surah,
                                      index: surah.number - 1,
                                      offset: bookmark.position,
                                    );
                                }));
                      },
                      bookmark: bookmark,
                      index: index,
                    );
                  },
                  itemCount: state.list.length,
                ),

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
