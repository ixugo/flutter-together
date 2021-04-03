import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_together/app.dart';
import 'package:flutter_together/common/global.dart';
import 'package:flutter_together/providers/app_state_model.dart';
import 'package:flutter_together/providers/theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 强制竖屏
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  Global.init().then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppStateModel>(
            create: (_) => AppStateModel()..loadProducts(),
          ),
          ChangeNotifierProvider<ThemeModel>(create: (_) => ThemeModel()),
        ],
        child: TogetherApp(),
      ),
    ),
  );
}
