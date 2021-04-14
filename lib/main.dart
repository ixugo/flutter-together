import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_together/app.dart';
import 'package:flutter_together/common/global.dart';
import 'package:flutter_together/providers/app_state_model.dart';
import 'package:flutter_together/providers/appbar.dart';
import 'package:flutter_together/providers/theme.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Global.init().then(
    (value) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppStateModel>(
            create: (_) => AppStateModel(),
          ),
          ChangeNotifierProvider<BottomAppbarModel>(
            create: (_) => BottomAppbarModel(),
          ),
          ChangeNotifierProvider<ThemeModel>(
            create: (_) => ThemeModel(),
          ),
        ],
        child: TogetherApp(),
      ),
    ),
  );
}
