import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class StaggeredView extends StatelessWidget {
  final ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    debugPrint("build StaggeredView");
    return Container(
      height: 1500,
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: new StaggeredGridView.countBuilder(
        //滑动控制器
        controller: _scrollController,
        primary: false,
        //滑动方向
        scrollDirection: Axis.vertical,
        //纵轴方向被划分的个数
        crossAxisCount: 2,
        //item的数量
        itemCount: 12,
        /**
           * mainAxisSpacing:主轴item之间的距离（px）
           * crossAxisSpacing:纵轴item之间的距离（px）
           * */
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        staggeredTileBuilder: (index) => StaggeredTile.fit(1),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: SizedBox(
              //随机生成高度
              height: 100 + Random().nextInt(10) * 20.0,
              width: 20,
              child: InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                          child: Text("瀑布卡片",
                              style: Theme.of(context).textTheme.bodyText2)),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 5, top: 5),
                      margin: EdgeInsets.only(bottom: 15),
                      color: Theme.of(context).accentColor,
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text("Title",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(
                                      color: Theme.of(context).primaryColor)),
                          Text(
                            "2021-04-02 18:00",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
