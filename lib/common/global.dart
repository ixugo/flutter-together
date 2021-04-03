import 'dart:convert';

import 'package:flutter_together/models/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Global {
  static SharedPreferences _prefs; // 存储
  static Profile profile = Profile(); // 配置

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print("出现错误 $e");
      }
    }
  }

  // 持久化Profile信息
  static saveProfile() =>
      _prefs.setString("profile", jsonEncode(profile.toJson()));
}
