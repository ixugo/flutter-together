import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_together/app.dart';
import 'package:flutter_together/common/global.dart';
import 'package:flutter_together/common/log.dart';
import 'package:flutter_together/providers/blog.dart';
import 'package:flutter_together/view/control.dart';
import 'package:flutter_together/view/input_blog_url.dart';
import 'package:flutter_together/widgets/toast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import 'grid_view.dart';

final svgGirl = SvgPicture.asset(
  "assets/images/single_girl.svg",
  width: 150,
);
final infomation = SvgPicture.asset(
  "assets/images/information.svg",
  width: 150,
);
final blogAdd = SvgPicture.asset(
  "assets/images/blog_add.svg",
  height: 200,
);

class HomeModel extends ChangeNotifier {
  // 绑定博客 URL 切换动画
  bool _isBindURL = () {
    // 验证域名
    RegExp url = new RegExp(r"^http(s)?://");
    if (url.hasMatch(Global.profile.blogUrl ?? "")) {
      return false;
    }
    return true;
  }();
  get isBindURL => _isBindURL;
  set isBindURL(bool x) {
    _isBindURL = x;
    notifyListeners();
  }

  ScrollController sctrl = ScrollController();
  bool isHeader = false;
  setHeader(bool v) {
    if (isHeader != v) {
      isHeader = v;
      notifyListeners();
    }
  }
}

//

class HomeView extends StatelessWidget {
  final SharedAxisTransitionType _transitionType =
      SharedAxisTransitionType.horizontal;

  @override
  Widget build(BuildContext ctx) {
    logs.i("build HomeView StatelessWidget");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeModel()),
        ChangeNotifierProvider(create: (_) => BlogModel()),
      ],
      child: Consumer<HomeModel>(builder: (ctx, am, child) {
        am.sctrl.addListener(() {
          if (am.sctrl.offset > 50) {
            am.setHeader(true);
          } else {
            am.setHeader(true);
          }
        });
        return _buildWithModel(ctx, am);
      }),
    );
  }

  Widget _buildWithModel(ctx, HomeModel am) {
    logs.i("build HomeView _buildWithModel");
    // final products = am.getProducts();
    return CustomScrollView(
      // controller: ModalScrollController.of(ctx),
      semanticChildCount: 1, // 文件长度
      slivers: <Widget>[
        CupertinoSliverNavigationBar(
          backgroundColor: Colors.white.withOpacity(0),
          largeTitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Together",
                style: TextStyle(color: Theme.of(ctx).accentColor),
              ),
              Visibility(
                visible: !am.isHeader,
                child: Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: InkWell(
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        "http://img.golang.space/1617351635695-xu2yhH.jpg",
                      ),
                    ),
                    onTap: () {
                      showCupertinoModalBottomSheet(
                        expand: true,
                        context: ctx,
                        backgroundColor: Colors.transparent,
                        builder: (ctx) => ControlView(),
                        duration: Duration(milliseconds: 370),
                        animationCurve: Curves.easeInOutQuad,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 1200),
            reverse: am.isBindURL,
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return SharedAxisTransition(
                fillColor: Colors.transparent,
                child: child,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: _transitionType,
              );
            },
            child: am.isBindURL ? InputBlogURLView() : BlogGridView(),
          ),
        ),
      ],
    );
  }
}

class InputBlogURLView extends StatelessWidget {
  onPressed(BuildContext ctx, BlogModel bm) {
    Future.delayed(Duration(milliseconds: 300), () async {
      String url = await showAvatarModalBottomSheet<String>(
        expand: true,
        ctx: ctx,
        backgroundColor: Colors.transparent,
        builder: (ctx) => ModalInsideModal(
          url: Global.profile.blogUrl,
        ),
      );
      if (url != null) {
        bm.setURL(url);
        Future.delayed(
          Duration(milliseconds: 700),
          () => Provider.of<HomeModel>(ctx, listen: false).isBindURL = false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext ctx) {
    BlogModel bm = Provider.of<BlogModel>(ctx, listen: false);
    logs.i("build InputBlogURLView");
    return Container(
      padding: EdgeInsets.only(top: 50),
      color: Theme.of(ctx).backgroundColor,
      child: Column(
        children: [
          svgGirl,
          SizedBox(height: 5),
          Text("Welcome to Together"),
          SizedBox(height: 5),
          TextButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                Size(double.infinity, 30),
              ),
            ),
            onPressed: () => onPressed(ctx, bm),
            child: Text("点此输入博客地址"),
          ),

          // TextField(),
        ],
      ),
    );
  }
}

class ModalInsideModal extends StatefulWidget {
  final String url;
  final bool reverse;
  ModalInsideModal({
    Key key,
    this.reverse = false,
    this.url = "",
  }) : super(key: key);
  @override
  _ModalInsideModalState createState() => _ModalInsideModalState();
}

class _ModalInsideModalState extends State<ModalInsideModal> {
  final FocusNode node = FocusNode();

  final TextEditingController ctrl = TextEditingController()
    ..text = "https://blog.golang.space";

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 200),
      () => FocusScope.of(navigatorKey.currentContext).requestFocus(node),
    );

    ctrl.text = widget.url;
  }

  @override
  Widget build(BuildContext ctx) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(ctx).appBarTheme.color,
        leading: Container(),
        middle: Text(
          '请输入博客地址',
          style: TextStyle(color: Theme.of(ctx).accentColor),
        ),
        trailing: TextButton(
          onPressed: () {
            String url = ctrl.text ?? "";
            RegExp urlRegExp = new RegExp(r"^http(s)?://");
            if (urlRegExp.hasMatch(url)) {
              showSuccess("即将跳转", Duration(milliseconds: 1000));
              return Navigator.pop(ctx, url);
            }
            showError("提交失败\n请检查正确性");
          },
          child: Text("确定"),
        ),
      ),
      child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
              child: Stack(
            children: [
              Container(height: 500),
              Padding(
                padding: EdgeInsets.only(top: 15, right: 25, left: 25),
                child: TextField(
                  controller: ctrl,
                  // autofocus: true,
                  focusNode: node,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(ctx).accentColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Theme.of(ctx).accentColor,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.yellow,
                      ),
                    ),
                    hintText: "http(s)://",
                  ),
                ),
              ),
              Align(
                heightFactor: 1.5,
                child: blogAdd,
                alignment: Alignment(0, 1),
              ),
            ],
          ))),
    ));
  }
}
