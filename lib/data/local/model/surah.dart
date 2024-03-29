class Surah {
  Surah(
      {this.number,
      this.name,
      this.englishName,
      this.englishNameTranslation,
      this.revelationType,
      this.page,
      this.numberOfAyat});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Surah &&
          runtimeType == other.runtimeType &&
          number == other.number;

  @override
  int get hashCode => number.hashCode;

  int number;
  String name;
  String englishName;
  String englishNameTranslation;
  String revelationType;
  int numberOfAyat;
  int page;

  factory Surah.fromMap(Map<String, dynamic> map) => Surah(
      number: map["id"],
      name: map["name"],
      page: map['page_id'],
      englishName: map["englishName"],
      englishNameTranslation: map["englishtranslation"],
      revelationType: map["revelationType"],
      numberOfAyat: map['numberOfAyats']);

  Map<String, dynamic> toMap() => {
        "number": 'id',
        "name": name,
        "page_id": page,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationType,
        "numberOfAyats": numberOfAyat,
      };

  @override
  String toString() {
    return "$name\n";
  }
}
