import 'package:flutter/material.dart';

class BottomAppbarModel extends ChangeNotifier {
  // 首页切换
  int _appbarCurrentIndex = 0;
  get curIndex => _appbarCurrentIndex;
  setCurIndex(int x) {
    _appbarCurrentIndex = x;
    notifyListeners();
  }
}
