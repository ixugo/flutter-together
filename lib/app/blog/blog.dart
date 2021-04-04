// 文章内容
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_together/app.dart';
import 'package:flutter_together/common/device.dart';
import 'package:flutter_together/widgets/toast.dart';

class BlogDetalView extends StatefulWidget {
  final String img;
  final Key key;
  BlogDetalView({this.key, this.img}) : super(key: key);
  @override
  BlogDetalViewState createState() => BlogDetalViewState();
}

class BlogDetalViewState extends State<BlogDetalView> {
  final ScrollController ctrl = ScrollController();
  bool isListener = true;

  @override
  void initState() {
    ctrl.addListener(() {
      debugPrint("滑动: ${ctrl.offset}");

      if (ctrl.offset < 0) {
        if (ctrl.offset < -50 && isListener) {
          isListener = false;
          navigatorKey.currentState.pop();
          debugPrint("pop 页面1: ${ctrl.offset}");
          return;
        }

        if (mounted) {
          setState(() {
            end = ctrl.offset.abs();
          });
        }
      }
    });

    super.initState();
  }

  double end = 0;

  @override
  Widget build(BuildContext ctx) {
    var w = Listener(
      onPointerDown: (v) {
        // 记录按下位置
        debugPrint("指针按下: ${v.localPosition.dy}");
      },
      onPointerMove: (v) {
        if (ctrl.offset < 0) {
          // 与按下位置比较滑动位置
          debugPrint("指针移动 触发关闭页面: ${v.localPosition.dy}  ${ctrl.offset}");
        }
      },
      child: _buildBody(ctx, widget.img),
    );

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: end),
      duration: Duration(milliseconds: 1000),
      builder: (ctx, v, _) {
        if (!mounted) {
          return Container();
        }

        return Material(
          color: Theme.of(ctx).backgroundColor.withOpacity(0.5),
          child: Padding(padding: EdgeInsets.all(v), child: w),
        );
      },
    );
  }

  Widget _buildBody(ctx, img) {
    Widget w = ListView(
      controller: ctrl,
      padding: EdgeInsets.zero,
      children: [
        Container(
          color: Theme.of(ctx).backgroundColor,
          width: double.infinity,
          height: 200,
          child: ClipRRect(
            // borderRadius: BorderRadius.circular(10),
            child: Image.network(
              img,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text("博文内容"),
        ),
        SizedBox(height: 1000),
        Center(
          child: Text("结束"),
        ),
      ],
    );

    //  TODO 避免遮挡,底部加一层模糊图片
    w = Stack(
      children: [
        w,
        Align(
          alignment: Alignment(0.9, -0.9),
          child: InkWell(
            onTap: () => Navigator.pop(ctx),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey[800].withOpacity(0.9),
              foregroundColor: Colors.grey[400],
              child: Icon(Icons.close),
            ),
          ),
        ),
      ],
    );

    return Material(
      color: Theme.of(ctx).scaffoldBackgroundColor,
      child: w,
    );
  }
}

class OpenContainerWrapper extends StatelessWidget {
  OpenContainerWrapper(
      {this.key, this.closedBuilder, this.transitionType, this.img})
      : super(key: key);

  final Key key;
  final String img;
  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext ctx) {
    return OpenContainer(
      transitionDuration: Duration(milliseconds: 370),
      openColor: Colors.transparent,
      closedColor: Theme.of(ctx).backgroundColor, // 同步背景色
      closedElevation: 0, // 关闭阴影
      transitionType: transitionType,
      openBuilder: (BuildContext ctx, VoidCallback _) {
        return BlogDetalView(
          key: Key(img),
          img: img,
        );
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
