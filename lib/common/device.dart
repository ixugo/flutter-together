import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';

class Apps {
  static EdgeInsets get winPadding => MediaQueryData.fromWindow(window).padding;
  static Size get winSize => MediaQueryData.fromWindow(window).size;

  static double get windowsTop => winPadding.top;
  static double get windowsBottom => winPadding.bottom;
  static double get windowsWidth => winSize.width;
  static double get windowsHeight => winSize.height;
  static String get operatingSystem => Platform.operatingSystem;
  static String get operatingSystemVersion => Platform.operatingSystemVersion;

  static bool isProduction = const bool.fromEnvironment("dart.vm.product");

  static void enableDebugPaint() {
    final pixe = MediaQueryData.fromWindow(window).devicePixelRatio;
    // Logs.debug('pixe: $pixe');
    // debugPaintSizeEnabled = true;
    // debugPaintLayerBordersEnabled = true;
    // debugRepaintRainbowEnabled = true;
    // debugProfilePaintsEnabled = true;
    // debugDumpLayerTree = true;
  }
}
