//
// Author: cauliflower
// Date: 2020-08-18 16:00:47
//
import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// toast 常用函数说明
/// 默认展示 2 秒
/// [showError] 位于屏幕中间, 矩形提示框, 图标为感叹号,
/// [showSuccess] 位于屏幕中间, 矩形提示框, 图标为对勾
/// [showTips] 位于屏幕下方 0.75 位置, 矩形文字提示框
/// [showIosDialogSingleButton] 只有一个确定按钮的对话框
/// [showIosDialog] 有确定和取消按钮的对话框

// showErrorBy400 显示错误码 400 的错误
void showErrorBy400(String desc) {
  if (Toast._isHideError400) {
    Toast.notHideErrorBy400();
    return;
  }
  Toast.closeAll();
  Toast._showCustomWidgetToast(desc, false);
}

void showError(String desc, [Duration time]) {
  Toast.closeAll();
  Toast._showCustomWidgetToast(desc, false, time: time);
}

void showSuccess(String desc, [Duration time]) {
  Toast.closeAll();
  Toast._showCustomWidgetToast(desc, true, time: time);
}

void showTips(String desc) {
  Toast.showBottomTips(desc);
}

/// [Toast] 弹窗提示封装,以下为函数说明
/// [showBottomTips] 屏幕下方文字提示
/// [closeAll] 关闭一切 toast
/// [close] 指定关闭某一个
/// [timerShowLoad] 延迟一秒执行的 showLoad
/// [showLoad] 加载动画
/// [showLoginTips] 登录提示, 仅用于登录界面
/// [cancelCurrent] 关闭当前的 toast
/// [_showCustomWidgetToast] 位于屏幕中间的矩形提示框,请勿直接使用,调用 [showError] or [showSuccess]
class Toast {
  /// [_tipsHeight] 底部长方形组件高
  /// [_tipsWidth] 底部长方形组件宽
  static const double _tipsHeight = 45;
  static const double _tipsWidth = 200;
  // 中间正方形组件宽高
  static const double _importentHeight = 100;
  static const double _importentWidth = 120;
  // 加载 toast 永远只有一个
  static CancelFunc _toast;
  // load
  static bool onlyLoad = false;
  // 默认提示时间为 2 秒
  static const Duration showTime = const Duration(seconds: 2);

  // 参数 : 描述/时间
  static CancelFunc showBottomTips(String desc, {Duration time = showTime}) {
    final wi = Container(
      height: _tipsHeight,
      width: _tipsWidth,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Center(
        child: Text(
          desc ?? "",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    return BotToast.showCustomText(
      toastBuilder: (_) => wi,
      align: Alignment(0, 0.70),
      animationReverseDuration: Duration(milliseconds: 200),
      duration: time,
      clickClose: true, // 触发任意事件关闭显示
      ignoreContentClick: false, // 不会触发提示范围内下一层page的事件
      onlyOne: true, // 组中唯一, 表示不可重叠
    );
  }

  // 用于控制 showErrorBy400 函数本次是否执行
  static bool _isHideError400 = false;

  // 隐藏 showError
  static hideErrorBy400() {
    _isHideError400 = true;
  }

  // 显示 showError
  static notHideErrorBy400() {
    _isHideError400 = false;
  }

  static closeAll() {
    BotToast.closeAllLoading();
  }

  static close(CancelFunc toast) {
    toast?.call();
  }

  static Timer timer;
  // timerShowLoad 延时一秒执行加载动画
  static timerShowLoad({int seconds = 1}) {
    if (timer == null) {
      timer = Timer(Duration(seconds: seconds), () => showLoad());
    }
  }

  // showLoad 展示加载动画
  static showLoad() {
    if (!onlyLoad) {
      onlyLoad = true;
      _toast = BotToast.showLoading(
        duration: Duration(seconds: 10),
      );
      Future.delayed(Duration(seconds: 10), () => cancelCurrent());
    }
  }

  // 登录中提示, 仅用于登录页面
  static showSlowLoginTips() {
    // if (timer == null) {
    // timer = Timer(Duration(milliseconds: 100), () {
    _toast = showBottomTips("登录中...", time: Duration(seconds: 10));
    // Future.delayed(Duration(seconds: 10), () => cancelCurrent());
    // });
    // }
  }

  // cancelCurrent 加载动画仅有唯一一个,该函数可以关闭 已加载或即将加载 的动画
  static cancelCurrent() {
    // 若有定时器, 立即关闭
    if (timer != null) {
      timer.cancel();
      timer = null;
    }
    // 关闭 当前 toast
    if (_toast != null) {
      _toast.call();
      _toast = null;
    }
    onlyLoad = false;
  }

  static showAttached(target, Widget child, {duration}) {
    _toast = BotToast.showAttachedWidget(
      duration: duration ?? Duration(seconds: 30),
      target: target,
      attachedBuilder: (_) => child,
      onlyOne: true,
    );
  }

  // showAttachedWidget 使用 target 定位, 在任意处加载
  static showAttachedWidget(target, String desc, {int seconds = 5}) {
    final w = Container(
      height: 50,
      width: 240,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: Text(
          desc ?? "",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
    BotToast.showAttachedWidget(
      duration: Duration(seconds: seconds),
      target: target,
      attachedBuilder: (_) => w,
    );
  }

  static _showCustomWidgetToast(str, bool flag, {Duration time}) {
    final w = Container(
      height: _importentHeight,
      width: _importentWidth,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                flag ? Icons.done : Icons.error_outline,
                color: Colors.white,
              ),
              Center(
                child: Text(
                  str,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
    BotToast.showCustomText(
      toastBuilder: (_) => w,
      duration: time ?? showTime,
      align: Alignment.center,
      onlyOne: true, // 唯一显示
      animationReverseDuration: Duration(milliseconds: 200), // 反向动画
    );
  }
}

// ios 选择对话框
Future<bool> showIosDialog(
  BuildContext ctx, {
  String title = "",
  String desc = "",
  String left = "取消", // 左侧按钮
  String right = "确定", // 右侧按钮
  bool quit = true, // 是否可以退出选择? false表示必须选择,不选择禁止退出弹窗
}) async {
  final dialog = CupertinoAlertDialog(
    title: Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Text(title,
          style: Theme.of(ctx).textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              )),
    ),
    content: Text(desc, style: Theme.of(ctx).textTheme.subtitle1),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text(left),
        onPressed: () => Navigator.pop(ctx, false),
      ),
      CupertinoDialogAction(
        child: Text(right),
        onPressed: () => Navigator.pop(ctx, true),
      ),
    ],
  );

  Widget child;
  if (!quit) {
    child = WillPopScope(
      onWillPop: () async => false,
      child: dialog,
    );
  } else {
    child = dialog;
  }

  bool temp = await showCupertinoDialog(context: ctx, builder: (ctx) => child);
  return temp;
}

//
Future<bool> showIosDialogSingleButton(
  BuildContext ctx, {
  String title = "",
  String desc = "",
  String right = "确定", // 右侧按钮
  bool quit = true, // 是否可以退出选择? false表示必须选择,不选择禁止退出弹窗
}) async {
  var dialog = CupertinoAlertDialog(
    title: Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Text(title,
          style: Theme.of(ctx).textTheme.subtitle1.copyWith(
                fontWeight: FontWeight.w600,
              )),
    ),
    content: Text(desc, style: Theme.of(ctx).textTheme.subtitle1),
    actions: <Widget>[
      CupertinoDialogAction(
        child: Text(right),
        onPressed: () => Navigator.pop(ctx, true),
      ),
    ],
  );

  Widget child;
  if (!quit) {
    child = WillPopScope(
      onWillPop: () async => false,
      child: dialog,
    );
  } else {
    child = dialog;
  }

  bool temp = await showCupertinoDialog(
    context: ctx,
    builder: (ctx) => child,
  );
  return temp;
}
