/// identifier : "ar.muyassar"
/// language : "ar"
/// name : "تفسير المیسر"
/// englishName : "King Fahad Quran Complex"
/// format : "text"
/// type : "tafsir"
/// direction : "rtl"

class Edition {
  String identifier;
  String language;
  int id;
  String name;
  String englishName;
  String format;
  String type;
  String direction;
  String media;
  bool selected = false;

  bool isSelected(int editionId) => editionId == id;

  void setSelected(bool isEqual) => selected = isEqual;

  Edition(
      {this.identifier,
      this.language,
      this.name,
      this.englishName,
      this.format,
      this.type,
      this.direction,
      this.media});

  Edition.fromMap(dynamic map) {
    identifier = map["identifier"];
    id = map["id"];
    language = map["language"];
    name = map["name"];
    englishName = map["englishname"];
    format = map["format"];
    type = map["type"];
    direction = map["direction"];
    media = map['media'] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["identifier"] = identifier;
    map["language"] = language;
    map["id"] = id;

    map["name"] = name;
    map["englishname"] = englishName;
    map["format"] = format;
    map["type"] = type;
    map["direction"] = direction;
    map['media'] = media;
    return map;
  }

  String languageFromCode() {
    switch (language) {
      case 'dv':
        return 'Divehi';
      case 'az':
        return 'Azerbaijani';
      case 'bn':
        return 'Bengali';
      case 'cs':
        return 'Czech';
      case 'de':
        return 'German';
      case 'en':
        return 'English';
      case 'fa':
        return 'Persian';
      case 'fr':
        return 'French';
      case 'ha':
        return 'Hausa';
      case 'hi':
        return 'Hindi';
      case 'id':
        return 'Indonesian';
      case 'it':
        return 'Italian';
      case 'ja':
        return 'Japanese';
      case 'ku':
        return 'Kurdish';
      case 'ml':
        return 'Malayalam';
      case 'nl':
        return 'Dutch';
      case 'no':
        return 'Norwegian';
      case 'pl':
        return 'Polish';
      case 'pt':
        return 'Portuguese';
      case 'ro':
        return 'Romanian';
      case 'ru':
        return 'Russian';
      case 'sd':
        return 'Sindhi';
      case 'so':
        return 'Somali';
      case 'sq':
        return 'Albanian';
      case 'sv':
        return 'Swedish';
      case 'vw':
        return 'Swahili';
      case 'ta':
        return 'Tamil';
      case 'tg':
        return 'Tajik';
      case 'th':
        return 'Thai';
      case 'tr':
        return 'Turkish';
      case 'ug':
        return 'Uighur';
      case 'ur':
        return 'Urdu';
      case 'uz':
        return 'Uzbek';
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'ms':
        return 'Malay';
      case 'zh':
        return 'Chinese';
      case 'bs':
        return 'Bosnian';
      case 'si':
        return 'Sinhala';
      case 'ar':
        return 'Arabic';
      case 'sw':
        return 'Swahili';
      case 'tt':
        return 'Tatar';

      default:
        return '';
    }
  }

  @override
  String toString() {
    return '$identifier:$type';
  }
}
