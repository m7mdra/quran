import 'package:flutter/material.dart';
import 'package:quran/data/model/bookmark.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../common.dart';

class BookmarkWidget extends StatelessWidget {
  final int index;
  final Bookmark bookmark;
  final Function(Bookmark) onTap;
  final Function(Bookmark) onDelete;

  const BookmarkWidget(
      {Key key, @required this.bookmark, this.index, this.onTap, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onTap?.call(bookmark);
        },
        trailing: IconButton(
          onPressed: () {
            onDelete.call(bookmark);
          },
          icon: Icon(Icons.delete_forever),
        ),
        tileColor: index % 2 == 0
            ? isDarkMode(context)
                ? Colors.black12
                : Color(0xfffcfcfc)
            : Colors.transparent,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: CircleAvatar(
                backgroundColor:
                    Color(0xff9cbd17).withAlpha((255 / 0.19).round()),
                child: Text("${index + 1}",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            VerticalDivider()
          ],
        ),
        title: Text(bookmark.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            )),
        subtitle: Text(
          timeago.format(bookmark.dateTime, clock: DateTime.now()),
          style: Theme.of(context).textTheme.caption,
        ));
  }
}
