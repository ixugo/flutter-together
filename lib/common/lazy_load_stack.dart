import 'package:flutter/material.dart';

// LazyIndexedStack 懒加载
class LazyIndexedStack extends StatefulWidget {
  final List<Widget> children;
  final int currentIndex;

  const LazyIndexedStack({
    Key key,
    this.children,
    this.currentIndex,
  }) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<LazyIndexedStack> {
  final initMap = <int, bool>{};

  @override
  void initState() {
    super.initState();
    initMap[0] = true;
  }

  @override
  Widget build(BuildContext ctx) {
    return IndexedStack(
      children: createChildren(),
      index: widget.currentIndex,
    );
  }

  List<Widget> createChildren() {
    final result = <Widget>[];
    for (var i = 0; i < widget.children.length; ++i) {
      final w = widget.children[i];
      if (initMap[i] == true) {
        result.add(w);
      } else {
        result.add(Container());
      }
    }
    return result;
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      initMap[widget.currentIndex] = true;
      setState(() {});
    }
  }
}
