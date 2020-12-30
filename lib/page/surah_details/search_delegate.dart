import 'package:flutter/material.dart';
import 'package:quran/data/local/quran_provider.dart';
import 'package:quran/data/model/quran.dart';
import 'normalization.dart';

class AyahSearchDelegate extends SearchDelegate<MapEntry<Surah, Ayah>> {
  final List<Surah> surah;

  AyahSearchDelegate(this.surah)
      : super(
            searchFieldStyle: TextStyle(color: Colors.grey),
            searchFieldLabel: 'ابحث عن ايات');

  @override
  List<Widget> buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton(
      color: Colors.white,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) => Theme.of(context);

  @override
  TextStyle get searchFieldStyle => TextStyle(color: Colors.white);

  @override
  Widget buildSuggestions(BuildContext context) {
    var result = findResult(query);
    if (result.isEmpty) return Text('no data');
    var list = result.values.toList();
    return ListView.separated(
      itemBuilder: (context, index) {
        return ListTile(
            onTap: () {
              Navigator.pop(context, result.entries.toList()[index]);
            },
            subtitle: Text(result.keys.toList()[index].name),
            leading: Text('﴿${list[index].numberInSurah}﴾',
                style: TextStyle(fontFamily: 'Al-QuranAlKareem')),
            title: Text(list[index].text,
                style: TextStyle(fontFamily: 'alquran', fontSize: 21)));
      },
      itemCount: list.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider();
      },
    );
  }

  Map<Surah, Ayah> findResult(String query) {
    print(query);
    if (query.isEmpty) return {};
    Map<Surah, Ayah> result = Map();
    surah.forEach((element) {
      var queryResult = element.ayahs.where((element) => element.text
          .replaceAll("بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيم", "")
          .normalize()
          .contains(query));
      if (queryResult.isNotEmpty) {
        result[element] = queryResult.first;
      }
      print(queryResult.length);
    });
    return result
      ..removeWhere((key, value) => value.text == null || value.text.isEmpty);
  }
}
