import 'package:flutter/material.dart';

abstract class TogetherTheme {
  // 共用属性
  static ThemeData general = ThemeData(
    platform: TargetPlatform.iOS,
  );

  // 文字颜色
  static final textDark = TextStyle(color: Colors.white);
  static final textLight = TextStyle(color: Colors.black87);

  // 较深背景色
  static final bgDark = Colors.grey[800];
  static final bgLight = Colors.white;

  // 暗色主题
  static ThemeData dart = general.copyWith(
    brightness: Brightness.dark,
    primaryColor: Colors.grey[800], // 主要部分背景色颜色  ToolBar,Tabbar 等
    primaryColorBrightness: Brightness.light, // primaryColor 上部的文本/图标颜色
    primaryColorLight: Colors.grey[600], // 较浅色
    primaryColorDark: Colors.grey[900], // 较深色
    accentColor: Colors.grey[50], // 前景色 按钮/文本/输入框等边缘效果
    accentColorBrightness: Brightness.light, // accentColor 上部的 按钮/图标颜色
    dividerColor: Colors.grey[50], // 分隔符颜色
    appBarTheme: AppBarTheme(
      color: bgDark,
      brightness: Brightness.light,
    ), // appbar
    bottomAppBarColor: bgDark, // 底部 appbar 颜色
    hintColor: Colors.white,
    buttonColor: Colors.white54,
    cardColor: Colors.grey[500],
    iconTheme: IconThemeData(color: Colors.white),
    textTheme: TextTheme(
      headline1: textDark,
      headline2: textDark,
      headline3: textDark,
      headline4: textDark,
      headline5: textDark,
      headline6: textDark,
      subtitle1: textDark,
      subtitle2: textDark,
      bodyText1: textDark, // 内容-粗 14
      bodyText2: textDark, // 内容-细 14
      caption: textDark,
    ),
    backgroundColor: Colors.grey[600],
    scaffoldBackgroundColor: Colors.grey[600],
  );

  // 亮色主题
  static ThemeData light = general.copyWith(
    brightness: Brightness.light,
    primaryColor: Colors.grey[50], // 主要部分背景色颜色  ToolBar,Tabbar 等
    primaryColorBrightness: Brightness.light, // primaryColor 上部的文本/图标颜色
    primaryColorLight: Colors.white, // 较浅色
    primaryColorDark: Colors.grey[100], // 较深色
    accentColor: Colors.black87, // 前景色 按钮/文本/边缘效果
    accentColorBrightness: Brightness.dark, // accentColor 上部的 按钮/图标颜色
    dividerColor: Colors.grey[500], // 分隔符颜色
    appBarTheme: AppBarTheme(
      color: bgLight,
      brightness: Brightness.light,
    ), // appbar
    bottomAppBarColor: bgLight, // 底部 appbar 颜色
    hintColor: Colors.black87,

    buttonColor: Colors.black87,
    cardColor: Colors.grey[300],
    iconTheme: IconThemeData(color: Colors.black87),
    textTheme: TextTheme(
      headline1: textLight,
      headline2: textLight,
      headline3: textLight,
      headline4: textLight,
      headline5: textLight,
      headline6: textLight,
      subtitle1: textLight,
      subtitle2: textLight,
      bodyText1: textLight, // 内容-粗 14
      bodyText2: textLight, // 内容-细 14
      caption: textLight,
    ),
    backgroundColor: Colors.grey[100],
    scaffoldBackgroundColor: Colors.grey[100],
  );
}
