class Tafseer {
  int ayaId;
  String ayaInfo;

  Tafseer({this.ayaId, this.ayaInfo});

  Tafseer.fromMap(Map map) {
    ayaId = map["AyaID"];
    ayaInfo = map["AyaInfo"];
  }
  Map<String,dynamic> toMap(){
    return {
      "AyaID" : ayaId,
      "AyaInfo" : ayaInfo,
    };
  }
}
