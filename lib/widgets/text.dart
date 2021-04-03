import 'package:flutter/material.dart';

class IText extends StatelessWidget {
  final String c;
  final TextStyle style;
  IText(this.c, {this.style = const TextStyle()});

  @override
  Widget build(BuildContext ctx) {
    return Text(
      c,
      style: style.copyWith(color: Theme.of(ctx).accentColor),
    );
  }
}
