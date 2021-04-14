class Article {
  String title;
  String createAt;
  List<String> tags;
  String link;
  String img;
  String description;

  Article({this.title, this.createAt, this.tags, this.link});

  Article.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    createAt = json['createAt'] ?? "";
    tags = json['tags'].cast<String>() ?? [];
    link = json['link'] ?? "";
    img = json["img"] ?? "";
    description = json["description"] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title ?? "";
    data['CreateAt'] = this.createAt ?? "";
    data['Tags'] = this.tags ?? [];
    data['link'] = this.link ?? "";
    return data;
  }
}
