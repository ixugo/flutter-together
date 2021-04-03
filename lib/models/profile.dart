class Profile {
  int theme; // 主题
  String blogUrl; // 博客地址

  Profile({this.theme, this.blogUrl});

  factory Profile.fromJson(Map<String, dynamic> json) {
    var theme = json['theme'] ?? 0;
    var blogUrl = json['blog_url'] ?? "";
    return Profile(theme: theme, blogUrl: blogUrl);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['theme'] = this.theme;
    data['blog_url'] = this.blogUrl;
    return data;
  }
}
