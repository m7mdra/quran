/// name : "سورة الاخلاص"
/// page_id : 10

class SuratInPage {
  String name;
  int pageId;

  SuratInPage({this.name, this.pageId});

  SuratInPage.fromMap(dynamic json) {
    name = json["name"];
    pageId = json["page_id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["page_id"] = pageId;
    return map;
  }
}
