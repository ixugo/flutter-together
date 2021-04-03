// 使用系统浏览器打开网页
import 'package:url_launcher/url_launcher.dart';

launchURL(url) async {
  if (await canLaunch(url)) {
    launch(url, forceWebView: false, forceSafariVC: false);
  } else {
    throw 'Could not launch $url';
  }
}
