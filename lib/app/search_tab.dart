import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() {
    return _SearchTabState();
  }
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
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
      ],
    );
  }
}
