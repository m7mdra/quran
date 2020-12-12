class Chapters {
  Chapters({
    this.data,
  });

  final List<Chapter> data;

  factory Chapters.fromJson(Map<String, dynamic> json) => Chapters(
    data: json["data"] == null ? null : List<Chapter>.from(json["data"].map((x) => Chapter.fromJson(x))),
  );

}

class Chapter {
  Chapter({
    this.id,
    this.title,
  });

  final int id;
  final String title;

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json["id"] == null ? null : json["id"],
    title: json["title"] == null ? null : json["title"],
  );


}