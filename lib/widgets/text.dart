import 'package:flutter/material.dart';

class IText extends StatelessWidget {
  final String c;
  final TextStyle style;
  IText(this.c, {this.style = const TextStyle()});

  @override
  Widget build(BuildContext context) {
    return Text(
      c,
      style: style.copyWith(color: Theme.of(context).accentColor),
    );
  }
}
