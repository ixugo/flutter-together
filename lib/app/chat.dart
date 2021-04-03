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
  Widget build(BuildContext context) {
    debugPrint("build SearchTab");
    return CustomScrollView(
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          backgroundColor: Theme.of(context).backgroundColor,
          largeTitle: Text(
            "Together",
            style: TextStyle(
              color: Theme.of(context).accentColor,
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
