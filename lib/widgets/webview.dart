import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebPage extends StatefulWidget {
  final String url;
  WebPage(this.url);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebPage> {
  bool load = true;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
    );
  }
}
