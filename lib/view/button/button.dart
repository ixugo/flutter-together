import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_together/app.dart';
import 'package:flutter_together/common/global.dart';
import 'package:flutter_together/common/log.dart';
import 'package:flutter_together/providers/theme.dart';
import 'package:provider/provider.dart';

class ChangeThemeButton extends StatefulWidget {
  @override
  _ChangeThemeButtonState createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  String currentAnimation =
      Global.profile.theme == 1 ? 'day_idle' : "night_idle";

  @override
  void initState() {
    super.initState();
    if (Global.profile.theme == 0) {
      var t = MediaQuery.platformBrightnessOf(navigatorKey.currentContext);
      currentAnimation = t == Brightness.light ? 'day_idle' : "night_idle";
    }
  }

  Widget build(BuildContext ctx) {
    logs.i("build ChangeThemeButton theme: ${Global.profile.theme}");

    // 切换皮肤按钮
    return Container(
      height: 45,
      width: 50,
      child: GestureDetector(
          onTap: () {
            if (currentAnimation == "day_idle") {
              currentAnimation = "switch_night";
            } else {
              currentAnimation = "switch_day";
            }
            Provider.of<ThemeModel>(context, listen: false).setTheme =
                Global.profile.theme == 1 ? 2 : 1;
          },
          child: FlareActor(
            "assets/flrs/switch_daytime.flr",
            // isPaused: _flag,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: currentAnimation,
            callback: (animationName) {
              switch (animationName) {
                // 更新按钮动画
                case "switch_day":
                  return setState(() {
                    currentAnimation = "day_idle";
                  });
                case "switch_night":
                  return setState(() {
                    currentAnimation = "night_idle";
                  });
              }
            },
          )),
    );
  }
}
