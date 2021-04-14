import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_together/common/device.dart';

class WebPage extends StatefulWidget {
  final String url;
  WebPage(this.url);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebPage> {
  bool load = true;

  double height = Apps.windowsHeight * 0.8;

  static const String HANDLER_NAME = 'InAppWebView';
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        onLoadStop: (InAppWebViewController c, Uri uri) async {
          int k = await c.getContentHeight();
          setState(() {
            height = k.toDouble() + 300;
          });
        },
      ),
    );
  }
}
