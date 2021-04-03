import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_together/common/global.dart';
import 'package:flutter_together/providers/theme.dart';
import 'package:provider/provider.dart';

class ChangeThemeButton extends StatefulWidget {
  @override
  _ChangeThemeButtonState createState() => _ChangeThemeButtonState();
}

class _ChangeThemeButtonState extends State<ChangeThemeButton> {
  String currentAnimation;

  Widget build(BuildContext ctx) {
    currentAnimation = () {
      if (Global.profile.theme == 0) {
        var t = MediaQuery.platformBrightnessOf(ctx);
        return t == Brightness.light ? 'day_idle' : "night_idle";
      }
      return Global.profile.theme == 1 ? 'day_idle' : "night_idle";
    }();

    // Theme.of(ctx).
    // 切换皮肤按钮
    return Container(
      height: 40,
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
                case "switch_day":
                  setState(() {
                    currentAnimation = "day_idle";
                  });
                  break;
                case "switch_night":
                  setState(() {
                    currentAnimation = "night_idle";
                  });

                  break;
                default:
              }
            },
          )),
    );
  }
}
