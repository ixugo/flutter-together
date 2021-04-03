import 'package:flutter/material.dart';
import 'package:flutter_together/common/global.dart';
import 'package:flutter_together/theme.dart';

/// 主题
class ThemeModel extends ChangeNotifier {
  // 获取当前主题
  ThemeData get getTheme {
    // 默认亮色
    if (Global.profile.theme == 0) {
      return TogetherTheme.light;
    }
    return TogetherTheme.dart;
  }

  // 主题改变后，通知其依赖项
  set setTheme(int i) {
    if (i != Global.profile.theme) {
      Global.profile.theme = i;
      Global.saveProfile();
      notifyListeners();
    }
  }
}
