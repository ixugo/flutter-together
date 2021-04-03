import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_together/app/button/button.dart';
import 'package:flutter_together/app/product_list_tab.dart';
import 'package:flutter_together/widgets/url_lanch.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// 操作列表类
class UserInfoListTile {
  final String title; // 名称
  final IconData icon; // 图标
  final Function action; // 动作
  Widget trailing; // 右侧开关

  UserInfoListTile(this.title, [this.icon, this.action, this.trailing]);
}

class ModalWithNavigator extends StatelessWidget {
  const ModalWithNavigator({Key key}) : super(key: key);

  Widget getList() {
    List<UserInfoListTile> list = [
      UserInfoListTile(
        "切换主题",
        Icons.art_track,
        null,
        ChangeThemeButton(),
      )
    ];

    return ListView.builder(
      shrinkWrap: true, //解决无限高度问题
      physics: new NeverScrollableScrollPhysics(), //禁用滑动事件
      padding: EdgeInsets.zero,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            list[index].title,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          // leading: Icon(
          //   userInfolisttile[index].icon,
          //   color: Theme.of(context).iconTheme.color,
          // ),
          onTap: list[index].action,
          trailing: list[index].trailing ??
              Icon(
                Icons.keyboard_arrow_right,
                color: Theme.of(context).iconTheme.color,
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return Material(
        color: Colors.black87,
        // child: Navigator(
        // onGenerateRoute: (_) => MaterialPageRoute(
        // builder: (context2) => Builder(
        // builder: (context) =>
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
            child: ListView(
                shrinkWrap: true,
                controller: ModalScrollController.of(ctx),
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
                  SizedBox(height: 300),
                  Center(
                    child: Text(
                      "version 0.1",
                    ),
                  ),
                  Center(
                    child: Text(
                      "共享者列表 ...待补充",
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Future.delayed(
                        Duration(milliseconds: 500),
                        () => launchURL("https://github.com/ixugo/go-together"),
                      );
                    },
                    child: Text("项目地址 : github.com/ixugo/go-together"),
                  ),
                ]),
          ),
          // ),
          // ),
          // ),
        ));
  }
}
