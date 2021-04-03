// 文章内容
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_together/common/global.dart';

class OpenContainerWrapper extends StatelessWidget {
  OpenContainerWrapper({this.closedBuilder, this.transitionType, this.img});

  // final Article data;
  final String img;
  final OpenContainerBuilder closedBuilder;
  final ContainerTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    var i = img;
    if (i == null) {
      i = "https://img.golang.space/shot-1617474467143.webp";
    }
    return OpenContainer(
      openColor: Colors.transparent,
      closedColor: Theme.of(context).backgroundColor, // 同步背景色
      closedElevation: 0, // 关闭阴影
      transitionType: transitionType,
      openBuilder: (BuildContext context, VoidCallback _) {
        return _detailsPage(context, i);
      },
      tappable: false,
      closedBuilder: closedBuilder,
    );
  }

  Widget _detailsPage(BuildContext context, String img) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('详情'),
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(children: <Widget>[
              Container(
                color: Theme.of(context).backgroundColor,
                width: double.infinity,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      img,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10),
              Center(
                child: Text("博文内容"),
              ),
              // Markdown(
              //   data: article.content, shrinkWrap: true, //解决无限高度问题
              //   selectable: true,
              //   physics: new NeverScrollableScrollPhysics(),
              //   syntaxHighlighter: _SyntaxHighlighter(),
              //   styleSheet: MarkdownStyleSheet(
              //       // img: TextStyle(),
              //       // code: TextStyle(
              //       //   fontFamily: "",
              //       //   color: Colors.orange,
              //       //   fontSize: 14,
              //       // ),
              //       ),
              // ), //禁用滑动事件),

              // Container(
              //   padding:
              //       EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 10),
              //   child: ListView(
              //       shrinkWrap: true, //解决无限高度问题
              //       physics: new NeverScrollableScrollPhysics(), //禁用滑动
              //       children: [
              //         Text("评论", style: Theme.of(context).textTheme.headline6),
              //       ]),
              // ),
            ]),
          ],
        ));
  }
}
