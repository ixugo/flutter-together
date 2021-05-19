class Profile {
  String blogUrl; // 博客地址

  Profile({this.blogUrl});

  factory Profile.fromJson(Map<String, dynamic> json) {
    var blogUrl = json['blog_url'] ?? "";
    return Profile(blogUrl: blogUrl);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['blog_url'] = this.blogUrl ?? "";
    return data;
  }
}
