import 'package:dio/dio.dart';
import 'package:flutter_together/api/api.dart';
import 'package:flutter_together/common/global.dart';
import 'package:flutter_together/common/log.dart';
import 'package:flutter_together/models/article.dart';
import 'package:flutter_together/providers/easy_refresh.dart';

class BlogModel extends EasyRefreshModel<Article> {
  // 填入的链接
  setURL(String v) {
    if (v != null) {
      logs.d(v);
      Global.profile.blogUrl = v;
      Global.saveProfile();
    }
    onRefresh();
  }

  @override
  Future<void> load() async {
    // Resp resp = await Api.getBlogList(path: next);
    // if (resp?.statusCode == 200) {
    //   next = resp.data["next"];
    //   for (var item in resp.data["data"]) {
    //     dataSource.add(Score.fromJson(item));
    //   }
    //   notifyListeners();
    // }
  }

  @override
  Future<void> refresh() async {
    Response resp = await Api.getBlogList(url: Global.profile.blogUrl);
    if (resp?.statusCode == 200) {
      next = resp.data["next"] ?? "";
      if (resp.data["data"] is List) {
        for (var item in resp.data["data"]) {
          dataSource.add(Article.fromJson(item));
        }
      }
      notifyListeners();
    }
  }
}
