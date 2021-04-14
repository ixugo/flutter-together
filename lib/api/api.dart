import 'package:dio/dio.dart';
import 'package:flutter_together/api/http.dart';

class Api {
  // 博客列表
  static Future<Response> getBlogList({String url = "", String path}) async {
    String defaultPath = "/blog";
    return await Http().get(path ?? defaultPath, params: {
      "url": url,
    });
  }
}
