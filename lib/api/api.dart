import 'package:flutter_together/api/http.dart';

class Api {
  static getBlogList(String url) async {
    String path = "/blog/list?url=$url";
    return await Http().get(path);
  }
}
