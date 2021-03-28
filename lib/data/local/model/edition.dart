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
  String name;
  String englishName;
  String format;
  String type;
  String direction;
  String media;

  Edition(
      {this.identifier,
      this.language,
      this.name,
      this.englishName,
      this.format,
      this.type,
      this.direction,
      this.media});

  Edition.fromMap(dynamic json) {
    identifier = json["identifier"];
    language = json["language"];
    name = json["name"];
    englishName = json["englishname"];
    format = json["format"];
    type = json["type"];
    direction = json["direction"];
    media = json['media'] ?? "";
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["identifier"] = identifier;
    map["language"] = language;
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

      default:
        return '';
    }
  }

  @override
  String toString() {
    return '$identifier:$type';
  }
}
