class Zekr {
  String title;
  List<Content> content;

  Zekr({
      this.title, 
      this.content});

  Zekr.fromJson(dynamic json) {
    title = json["title"];
    if (json["content"] != null) {
      content = [];
      json["content"].forEach((v) {
        content.add(Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["title"] = title;
    if (content != null) {
      map["content"] = content.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Content {
  String zekr;
  int repeat;
  String bless;

  Content({
      this.zekr, 
      this.repeat, 
      this.bless});

  Content.fromJson(dynamic json) {
    zekr = json["zekr"];
    repeat = json["repeat"];
    bless = json["bless"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["zekr"] = zekr;
    map["repeat"] = repeat;
    map["bless"] = bless;
    return map;
  }

}