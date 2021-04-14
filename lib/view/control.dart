import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_together/view/button/button.dart';
import 'package:flutter_together/view/home.dart';
import 'package:flutter_together/widgets/url_lanch.dart';

// 操作列表类
class UserInfoListTile {
  final String title; // 名称
  final IconData icon; // 图标
  final String subTitle; // 描述
  final Function action; // 动作
  Widget trailing; // 右侧开关

  UserInfoListTile(
    this.title, [
    this.icon,
    this.action,
    this.trailing,
    this.subTitle,
  ]);
}

class ControlView extends StatelessWidget {
  const ControlView({Key key}) : super(key: key);

  Widget getList() {
    List<UserInfoListTile> list = [
      UserInfoListTile(
        "切换主题",
        Icons.art_track,
        () => {},
        ChangeThemeButton(),
      )
    ];

    return ListView.builder(
      shrinkWrap: true, //解决无限高度问题
      physics: new NeverScrollableScrollPhysics(), //禁用滑动事件
      padding: EdgeInsets.zero,
      itemCount: list.length,

      itemBuilder: (ctx, index) {
        return ListTile(
          title: Text(
            list[index].title,
            style: Theme.of(ctx).textTheme.bodyText2,
          ),
          onTap: list[index].action,
          trailing: list[index].trailing ??
              Icon(
                Icons.keyboard_arrow_right,
                color: Theme.of(ctx).iconTheme.color,
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Material(
      color: Colors.black87,
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Theme.of(ctx).appBarTheme.color,
          leading: Container(),
          middle: Text(
            '用户控制中心',
            style: TextStyle(color: Theme.of(ctx).accentColor),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
              // shrinkWrap: true,
              // controller: ModalScrollController.of(ctx),
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 50),
                    infomation,
                    SizedBox(height: 20),
                    Center(
                      child: Text("应用控制/皮肤/账号管理/等均在此"),
                    ),
                    SizedBox(height: 30),
                    Divider(height: 0),
                    getList(),
                    Divider(height: 0),
                  ],
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "version 0.1",
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      "著 作 者 : ixugo",
                      style: TextStyle(fontSize: 11),
                    ),
                    Text(
                      "贡 献 者 : 王博",
                      style: TextStyle(fontSize: 11),
                    ),
                    TextButton(
                      onPressed: () {
                        Future.delayed(
                          Duration(milliseconds: 500),
                          () =>
                              launchURL("https://github.com/ixugo/go-together"),
                        );
                      },
                      child: Text("项目地址 : github.com/ixugo/go-together"),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
