import 'dart:math';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_together/common/log.dart';
import 'package:flutter_together/models/article.dart';
import 'package:flutter_together/providers/blog.dart';
import 'package:flutter_together/view/blog/blog.dart';
import 'package:provider/provider.dart';

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

class BlogGridView extends StatelessWidget {
  final ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  final ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext ctx) {
    logs.i("build StaggeredView");

    Provider.of<BlogModel>(ctx, listen: false).onRefresh();

    return Consumer<BlogModel>(builder: (BuildContext ctx, BlogModel bm, _) {
      // return EasyRefresh(
      // controller: bm.easyRefreshController,
      // header: MaterialHeader(),
      // footer: MaterialFooter(),
      // onRefresh: bm.onRefresh,
      // child: buildWithModel(ctx, bm),
      // );
      //
      return buildWithModel(ctx, bm);
    });
  }

  Widget buildWithModel(BuildContext ctx, BlogModel bm) {
    double len = (bm.dataSource?.length ?? 0).toDouble();
    return Container(
      height: len * 150,
      // color: Theme.of(ctx).backgroundColor,
      padding: EdgeInsets.only(left: 10, right: 10, top: 20),
      child: StaggeredGridView.countBuilder(
          //滑动控制器
          controller: _scrollController,
          primary: false,
          //滑动方向
          scrollDirection: Axis.vertical,
          //纵轴方向被划分的个数
          crossAxisCount: 2,
          //item的数量
          itemCount: bm.dataSource?.length ?? 0,
          /**
           * mainAxisSpacing:主轴item之间的距离（px）
           * crossAxisSpacing:纵轴item之间的距离（px）
           * */
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          staggeredTileBuilder: (index) => StaggeredTile.fit(1),
          itemBuilder: (BuildContext ctx, int i) {
            Article val = bm.dataSource[i];

            if (val.img.length <= 0) {
              val.img = list[Random().nextInt(list.length)]["img"] as String;
            }

            return OpenContainerWrapper(
              key: Key(i.toString()),
              transitionType: _transitionType,
              article: val,
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
                              image: NetworkImage(val.img),
                            ),
                          ),
                          buildContent(ctx, val),
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

  Widget buildContent(BuildContext ctx, Article a) {
    return Expanded(
      child: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                a.title,
                style: Theme.of(ctx).textTheme.bodyText1.copyWith(
                      color: Theme.of(ctx).accentColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
              ),
              Text(
                a.createAt,
                style: Theme.of(ctx).textTheme.bodyText2.copyWith(
                      color: Theme.of(ctx).accentColor,
                      fontSize: 12,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
