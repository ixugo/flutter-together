import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_together/common/lazy_load_stack.dart';
import 'package:flutter_together/providers/appbar.dart';
import 'package:flutter_together/theme.dart';
import 'package:flutter_together/view/chat.dart';
import 'package:flutter_together/view/home.dart';
import 'package:flutter_together/widgets/will_pop_scope.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class TogetherApp extends StatelessWidget {
  final taskTitle = "Together";

  MaterialWithModalsPageRoute onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialWithModalsPageRoute(
          builder: (_) => CupertinoHomePage(),
          settings: settings,
        );
    }
    return null;
  }

  @override
  Widget build(BuildContext ctx) {
    // 强制竖屏
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    // 安卓沉浸式状态栏
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    return _buildWithModel(ctx);
  }

  Widget _buildWithModel(BuildContext ctx) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: taskTitle,
      theme: TogetherTheme.light,
      darkTheme: TogetherTheme.dart,
      navigatorKey: navigatorKey,
      builder: BotToastInit(),
      navigatorObservers: <NavigatorObserver>[
        BotToastNavigatorObserver(),
      ],
      onGenerateRoute: onGenerateRoute,
    );
  }
}

class AppPage {
  final Widget w;
  final IconData icon;

  AppPage(this.w, this.icon);
}

final List<AppPage> pages = [
  AppPage(HomeView(), Icons.attachment),
  AppPage(ChatView(), CupertinoIcons.chat_bubble_2),
];

class CupertinoHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext ctx) {
    return Consumer<BottomAppbarModel>(builder: _buildWithModel);
  }

  Widget _buildWithModel(ctx, BottomAppbarModel bm, _) {
    return WillPop(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          onTap: (int i) => bm.setCurIndex(i),
          color: Theme.of(ctx).bottomAppBarColor,
          backgroundColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 520),
          height: Platform.isIOS ? 65 : 60,
          animationCurve: Curves.easeOutCubic,
          items: pages.map((e) => Icon(e.icon, size: 30)).toList(),
        ),
        body: LazyIndexedStack(
          currentIndex: bm.curIndex,
          children: pages.map((e) => e.w).toList(),
        ),
      ),
    );
  }
}
