/// edition_id : 1
/// hizbQuarter_id : 1
/// id : 1
/// juz_id : 1
/// manzil_id : 1
/// number : 1
/// numberinsurat : 1
/// page_id : 1
/// ruku_id : 1
/// sajda_id : null
/// surat_id : 1
/// text : "سورة الفاتحة سميت هذه السورة بالفاتحة؛ لأنه يفتتح بها القرآن العظيم، وتسمى المثاني؛ لأنها تقرأ في كل ركعة، ولها أسماء أخر. أبتدئ قراءة القرآن باسم الله مستعينا به، (اللهِ) علم على الرب -تبارك وتعالى- المعبود بحق دون سواه، وهو أخص أسماء الله تعالى، ولا يسمى به غيره سبحانه. (الرَّحْمَنِ) ذي الرحمة العامة الذي وسعت رحمته جميع الخلق، (الرَّحِيمِ) بالمؤمنين، وهما اسمان من أسمائه تعالى، يتضمنان إثبات صفة الرحمة لله تعالى كما يليق بجلاله."

class Ayah {
  int editionId;
  int hizbQuarterId;
  int id;
  int juzId;
  int manzilId;
  int number;
  int numberInSurah;
  int pageId;
  int rukuId;
  int suratId;
  String text;

  Ayah({
      this.editionId, 
      this.hizbQuarterId, 
      this.id, 
      this.juzId, 
      this.manzilId, 
      this.number, 
      this.numberInSurah, 
      this.pageId, 
      this.rukuId, 
      this.suratId,
      this.text});

  Ayah.fromMap(dynamic json) {
    editionId = json["edition_id"];
    hizbQuarterId = json["hizbQuarter_id"];
    id = json["id"];
    juzId = json["juz_id"];
    manzilId = json["manzil_id"];
    number = json["number"];
    numberInSurah = json["numberinsurat"];
    pageId = json["page_id"];
    rukuId = json["ruku_id"];
    suratId = json["surat_id"];
    text = json["text"];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map["edition_id"] = editionId;
    map["hizbQuarter_id"] = hizbQuarterId;
    map["id"] = id;
    map["juz_id"] = juzId;
    map["manzil_id"] = manzilId;
    map["number"] = number;
    map["numberinsurat"] = numberInSurah;
    map["page_id"] = pageId;
    map["ruku_id"] = rukuId;
    map["surat_id"] = suratId;
    map["text"] = text;
    return map;
  }

  @override
  String toString() {
    return 'Ayah{id: $id, juzId: $juzId, numberInSurah: $numberInSurah, text: $text}';
  }
}