import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_together/app/home.dart';
import 'package:flutter_together/app/chat.dart';
import 'package:flutter_together/common/lazy_load_stack.dart';
import 'package:flutter_together/providers/app_state_model.dart';
import 'package:flutter_together/providers/theme.dart';
import 'package:flutter_together/theme.dart';
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
  Widget build(BuildContext context) {
    // 安卓沉浸式状态栏
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    return Consumer<ThemeModel>(builder: (BuildContext ctx, tm, _) {
      return _buildWithModel(ctx, tm);
    });
  }

  Widget _buildWithModel(BuildContext ctx, ThemeModel tm) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: taskTitle,
      theme: TogetherTheme.light,
      darkTheme: TogetherTheme.dart,
      themeMode: tm.getTheme,
      navigatorKey: navigatorKey,
      builder: BotToastInit(),
      navigatorObservers: <NavigatorObserver>[
        BotToastNavigatorObserver(),
      ],
      onGenerateRoute: onGenerateRoute,
    );
  }
}

class CupertinoHomePage extends StatelessWidget {
  final List<Map> pages = [
    {
      "widget": HomeView(),
      "icon": Icons.attachment,
    },
    {
      "widget": ChatView(),
      "icon": CupertinoIcons.chat_bubble_2,
    },
  ];
  @override
  Widget build(BuildContext ctx) {
    return Consumer<AppStateModel>(builder: _buildWithModel);
  }

  Widget _buildWithModel(ctx, AppStateModel am, _) {
    var a = Theme.of(ctx).accentColor;
    return WillPop(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          onTap: (int i) => am.setCurIndex(i),
          color: Theme.of(ctx).bottomAppBarColor,
          backgroundColor: Colors.transparent,
          animationDuration: Duration(milliseconds: 370),
          height: Platform.isIOS ? 65 : 60,
          items: pages.map((e) => Icon(e["icon"], size: 30)).toList(),
        ),
        body: LazyIndexedStack(
          currentIndex: am.curIndex,
          children: pages
              .map((e) => CupertinoPageScaffold(child: e["widget"] as Widget))
              .toList(),
        ),
      ),
    );
  }
}
