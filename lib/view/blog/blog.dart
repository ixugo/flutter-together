// 文章内容
import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_together/app.dart';
import 'package:flutter_together/common/log.dart';
import 'package:flutter_together/models/article.dart';
import 'package:flutter_together/widgets/url_lanch.dart';
import 'package:flutter_together/widgets/webview.dart';

// TODO 下啦后上滑会引发异常
class BlogDetalView extends StatefulWidget {
  final Article article;
  final Key key;
  BlogDetalView({this.key, this.article}) : super(key: key);
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
        // -40 指的是下拉高度
        if (ctrl.offset < -40 && isListener) {
          isListener = false;

          // 延迟检测，如果达到了但是用户不松手, 强制关闭
          Future.delayed(Duration(milliseconds: 500), () {
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
            // 获取圆角
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
            child: _buildBody(ctx, widget.article.img),
          ),
        );
      },
    );
  }

  Widget _buildBody(ctx, img) {
    Widget w = WebPage(widget.article.link);

    final double height = 210;
    w = CustomScrollView(
      // physics: NeverScrollableScrollPhysics(),
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
      child: Stack(children: [
        Column(
          children: [
            Container(
              height: 240,
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              // color: Colors.red,
              child: Text(
                "轻微下拉关闭",
                style: TextStyle(fontSize: 11),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              height: 150,
              child: Text("ixugo"),
            ),
          ],
        ),
        w,
      ]),
    );
  }
}

class OpenContainerWrapper extends StatelessWidget {
  OpenContainerWrapper(
      {this.key, this.closedBuilder, this.transitionType, this.article})
      : super(key: key);

  final Key key;
  final Article article;
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
        if (!article.link.contains("golang.space")) {
          // launchURL(article.link);
          // return null;
          //
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => IWebView(article.link)),
          );
          return null;
        }
        return BlogDetalView(
          key: Key(article.link),
          article: article,
        );
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }
}
