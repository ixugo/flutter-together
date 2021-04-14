//
// Author: cauliflower
// Date: 2020-09-09 16:41:52
//

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_together/common/log.dart';

/// [EasyRefreshModel] 用于 下拉刷新/上啦加载
/// 需要的页面 model 继承此类，将实现功能必须的变量定义，子类实现 load/refresh 加载数据即可
/// 使用方法可参考 attention.dart 文件中 [AttentionModel]
abstract class EasyRefreshModel<T> extends ChangeNotifier {
  /// [refresh] 需要重写刷新方法 , 调用 [onRefresh]
  Future<void> refresh();

  /// [load] 需要重写加载方法,调用 [onLoad]
  Future<void> load();

  /// [onLoad] 上拉刷新时执行
  /// 先判断是否还有数据待加载, 有则执行回调函数
  Future<void> onLoad() async {
    bool hasMore = hasNext();
    if (hasMore) {
      await load();
    }
    hasMore = hasNext();
    easyRefreshController.finishLoad(success: true, noMore: !hasMore);
  }

  /// [next] 下一页 API
  String next;

  /// [hasNext] 是否有下一页?
  hasNext() {
    if (next == "") {
      return false;
    }
    return true;
  }

  /// [onRefresh] 下拉刷新时执行
  /// 清空旧数据, 重新加载数据
  Future<void> onRefresh() async {
    dataSource = [];
    try {
      await refresh();
    } catch (e) {
      logs.e("列表请求异常", e);
    }
    bool hasMore = hasNext();
    easyRefreshController..finishRefresh(success: true);
    easyRefreshController.finishLoad(success: true, noMore: !hasMore);
  }

  /// [easyRefreshController] 刷新加载控制器
  EasyRefreshController easyRefreshController = EasyRefreshController();

  /// [data] 数据
  List<T> dataSource;

  @override
  void dispose() {
    easyRefreshController?.dispose();
    super.dispose();
  }

  notifyListeners() {
    super.notifyListeners();
  }
}
