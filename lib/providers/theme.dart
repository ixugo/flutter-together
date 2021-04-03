import 'package:flutter/material.dart';
import 'package:flutter_together/common/global.dart';

/// 主题
class ThemeModel extends ChangeNotifier {
  // 获取当前主题
  ThemeMode get getTheme {
    switch (Global.profile.theme) {
      case 0:
        return ThemeMode.system; // 跟随系统
      case 1:
        return ThemeMode.light; // 亮色
      default:
        return ThemeMode.dark; // 暗色
    }
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
