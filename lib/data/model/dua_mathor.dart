class DuaMathor {
  String value;

  DuaMathor({
      this.value});

  DuaMathor.fromJson(dynamic json) {
    value = json["value"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["value"] = value;
    return map;
  }

}