// 文章内容
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_together/app.dart';
import 'package:flutter_together/common/log.dart';

// TODO 下啦后上滑会引发异常
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
  double circular = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    ctrl.addListener(() {
      if (ctrl.offset < 0) {
        if (ctrl.offset < -50 && isListener) {
          isListener = false;

          Future.delayed(Duration(milliseconds: 600), () {
            SystemChrome.setEnabledSystemUIOverlays(
                [SystemUiOverlay.top, SystemUiOverlay.bottom]);
            if (mounted) {
              navigatorKey.currentState.pop();
            }
          });

          logs.i("pop 页面: ${ctrl.offset}");
          return;
        }

        if (mounted) {
          setState(() {
            end = ctrl.offset.abs() < 40 ? ctrl.offset.abs() : 40;
            circular = getCircular();
            logs.i("滑动: ${ctrl.offset}  circular:$circular");
          });
        }
      }

      if (ctrl.offset > 0 && end != 0) {
        setState(() {
          end = 0;
        });
      }
    });

    super.initState();
  }

  double end = 0;

  double getCircular() {
    if (ctrl.offset < -1 && ctrl.offset > -20) {
      return ctrl.offset.abs() / 2;
    }
    if (ctrl.offset < -20) {
      return 10;
    }
    return 0;
  }

  @override
  Widget build(BuildContext ctx) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: end),
      duration: Duration(milliseconds: 80),
      curve: Curves.easeOutBack,
      builder: (ctx, double v, _) {
        if (!mounted) {
          return Material();
        }

        if (v == null) v = 0;
        return Material(
          color: Theme.of(ctx).backgroundColor.withOpacity(0.5),
          child: Padding(
            padding:
                EdgeInsets.only(left: v, right: v, top: v * 2, bottom: v * 2),
            child: _buildBody(ctx, widget.img),
          ),
        );
      },
    );
  }

  Widget _buildBody(ctx, img) {
    Widget w = Column(
      children: [
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

    final double height = 220;
    w = CustomScrollView(
      controller: ctrl,
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          key: Key("2"),
          expandedHeight: height,
          automaticallyImplyLeading: false,
          flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(circular - 2),
                topRight: Radius.circular(circular - 2),
              ),
              child: Image.network(
                img,
                fit: BoxFit.cover,
              ),
            );
          }),
        ),
        SliverToBoxAdapter(
          key: Key("1"),
          child: w,
        )
      ],
    );

    //  TODO 避免遮挡,底部加一层模糊图片
    w = Stack(
      children: [
        w,
        Align(
          alignment: Alignment(0.9, -0.95),
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
      borderRadius: BorderRadius.circular(circular),
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
