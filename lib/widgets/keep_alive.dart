//
// Author: cauliflower
// Date: 2020-07-27
//

import 'package:flutter/material.dart';

// tabbar-tabbarview 中组件状态保持
class KeepAliveView extends StatefulWidget {
  final Widget child;

  KeepAliveView({this.child});
  @override
  _KeepAliveViewState createState() => _KeepAliveViewState();
}

class _KeepAliveViewState extends State<KeepAliveView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
