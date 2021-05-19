// 使用系统浏览器打开网页
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_together/common/log.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

launchURL(url) async {
  if (await canLaunch(url)) {
    launch(url, forceWebView: false, forceSafariVC: false);
  } else {
    throw 'Could not launch $url';
  }
}

class IWebView extends StatefulWidget {
  final String url;
  IWebView(this.url);
  @override
  _IWebViewState createState() => _IWebViewState();
}

class _IWebViewState extends State<IWebView> {
  bool load = true;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext ctx) {
    logs.d("build _IWebViewState ${widget.url}");
    final body = Stack(
      children: [
        getWebView(ctx),
        Visibility(
          child: Center(child: CircularProgressIndicator()),
          visible: load,
        )
      ],
    );
    return Container(
      height: 600,
      child: body,
    );
  }

  Widget getWebView(BuildContext ctx) {
    final onWebViewCreated = (WebViewController webViewController) {
      _controller.complete(webViewController);
    };
    final navigationDelegate = (NavigationRequest request) {
      // NavigationDecision.prevent：阻止路由替换；
      // NavigationDecision.navigate：允许路由替换。

      return NavigationDecision.navigate;
    };

    final onPageFinished = (String url) {
      this.setState(() {
        load = false;
      });
    };

    return WebView(
      initialUrl: widget.url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: onWebViewCreated,
      navigationDelegate: navigationDelegate,
      onPageFinished: onPageFinished,
    );
  }
}
