import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() {
    return _ChatViewState();
  }
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext ctx) {
    debugPrint("build ChatView");
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          backgroundColor: Theme.of(ctx).backgroundColor,
          largeTitle: Text(
            "Together",
            style: TextStyle(
              color: Theme.of(ctx).accentColor,
            ),
          ),
        ),
        SliverToBoxAdapter(
            child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: Text("通讯聊天, 敬请期待"),
          ),
        ))
      ],
    );
  }
}
