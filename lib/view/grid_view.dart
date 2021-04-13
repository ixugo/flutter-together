import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_together/view/blog/blog.dart';

List<Map> list = [
  {"img": "https://img.golang.space/shot-1617474467143.webp"},
  {
    "img": "https://img.golang.space/shot-1617474196403.png",
  },
  {
    "img": "https://img.golang.space/shot-1617474381018.jpg",
  },
  {
    "img": "https://img.golang.space/shot-1617474391279.png",
  },
  {"img": "https://img.golang.space/shot-1617474416796.png"},
  {"img": "https://img.golang.space/shot-1617474429389.jpg"},
  {"img": "https://img.golang.space/shot-1617474450090.png"},
  {"img": "https://img.golang.space/shot-1617474459735.png"},
  {"img": "https://img.golang.space/shot-1617474479143.webp"},
  {"img": "https://img.golang.space/shot-1617474562452.jpg"},
];

class StaggeredModel extends ChangeNotifier {}

class StaggeredView extends StatelessWidget {
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  final ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext ctx) {
    debugPrint("build StaggeredView");

    // return ChangeNotifierProvider(
    //   create: (_) => StaggeredModel(),
    //   child: Consumer<StaggeredModel>(builder: buildWithModel),
    // );
    //
    return buildWithModel(ctx, null, null);
  }

  Widget buildWithModel(ctx, sm, _) {
    Widget content = Expanded(
      child: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Title",
                style: Theme.of(ctx)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Theme.of(ctx).accentColor),
              ),
              Text(
                "2021-04-02 18:00",
                style: Theme.of(ctx)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Theme.of(ctx).accentColor),
              ),
            ],
          ),
        ),
      ),
    );
    return Container(
      height: 1300,
      // color: Theme.of(ctx).backgroundColor,
      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: new StaggeredGridView.countBuilder(
          //滑动控制器
          controller: _scrollController,
          primary: false,
          //滑动方向
          scrollDirection: Axis.vertical,
          //纵轴方向被划分的个数
          crossAxisCount: 2,
          //item的数量
          itemCount: list.length,
          /**
           * mainAxisSpacing:主轴item之间的距离（px）
           * crossAxisSpacing:纵轴item之间的距离（px）
           * */
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          itemBuilder: (BuildContext ctx, int i) {
            return OpenContainerWrapper(
              key: Key(i.toString()),
              transitionType: _transitionType,
              img: list[i]["img"] as String,
              closedBuilder: (BuildContext _, VoidCallback openContainer) {
                return Card(
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: SizedBox(
                    //随机生成高度
                    height: 180 + Random(i).nextInt(20) * 5.0,
                    width: 20,
                    child: InkWell(
                      onTap: openContainer,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(list[i]["img"]),
                            ),
                          ),
                          content,
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
