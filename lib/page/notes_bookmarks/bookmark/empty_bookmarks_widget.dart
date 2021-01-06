
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class EmptyBookmarksWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset('assets/images/empty_bookmarks.svg'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("لا توجد علامات حفظ حتي الأن",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                )),
          ),

        ],
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
