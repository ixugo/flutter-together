//
// Author: cauliflower
// Date: 2020-07-21 10:57:34
//

import 'package:flutter/material.dart';
import 'package:flutter_together/widgets/toast.dart';

/// [WillPop] 退出提示,避免误操作, 用于未存储数据返回等场景
class WillPop extends StatelessWidget {
  @required
  final Widget child; // ui 界面
  final Future<bool> Function() action; // 自定义退出调用函数, 不传则使用默认
  final bool isNull; //  默认为 flase , 若设置 true, 则不阻拦返回
  final String desc; // 若不传递调用函数, 默认样式的提示信息
  WillPop({
    this.child,
    this.action,
    this.isNull = false,
    this.desc = "再次点击退出",
  }) : assert(child != null);
  // assert(false) 触发异常警报

  @override
  Widget build(BuildContext ctx) {
    //返回间隔时间
    DateTime _lastPressedAdt;
    // 没有自定义函数, 则使用默认方法
    final defaultAction = action ??
        () async {
          // 默认 2 秒内两次滑动,可返回, 两次间隔超过 1 秒提示需再次滑动
          if (_lastPressedAdt == null ||
              DateTime.now().difference(_lastPressedAdt) >
                  Duration(milliseconds: 2000)) {
            showError(desc, Duration(milliseconds: 1600));
            //两次点击时间间隔超过1秒则重新计时
            _lastPressedAdt = DateTime.now();
            return false; // 禁止返回
          }
          return true; // 允许返回
        };
    return WillPopScope(child: child, onWillPop: isNull ? null : defaultAction);
  }
}
