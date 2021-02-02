class Surah {
  Surah({
    this.number,
    this.name,
    this.englishName,
    this.englishNameTranslation,
    this.revelationType,
  });

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

  factory Surah.fromMap(Map<String, dynamic> json) => Surah(
      number: json["id"],
      name: json["name"],
      englishName: json["englishName"],
      englishNameTranslation: json["englishtranslation"],
      revelationType: json["revelationType"],
  );

  Map<String, dynamic> toMap() => {
        "number": 'id',
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationType
      };

  @override
  String toString() {
    return "$name\n";
  }
}
