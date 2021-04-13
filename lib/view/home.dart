import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_together/common/log.dart';
import 'package:flutter_together/providers/app_state_model.dart';
import 'package:flutter_together/styles.dart';
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
final blogAdd = SvgPicture.asset("assets/images/blog_add.svg", height: 200);

class HomeModel extends ChangeNotifier {
  // 绑定博客 URL 切换动画
  bool _isBindURL = true;
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
    return ChangeNotifierProvider(
      create: (_) => HomeModel(),
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
                      backgroundImage: NetworkImage(
                        "https://img.golang.space/1617351635695-xu2yhH.jpg",
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
            child: am.isBindURL ? InputBlogURLView() : StaggeredView(),
          ),
        ),
      ],
    );
  }
}

class InputBlogURLView extends StatelessWidget {
  onPressed(ctx) {
    Future.delayed(
      Duration(milliseconds: 300),
      () => showAvatarModalBottomSheet(
        expand: true,
        ctx: ctx,
        backgroundColor: Colors.transparent,
        builder: (ctx) => ModalInsideModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
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
            onPressed: () => onPressed(ctx),
            child: Text("点此输入博客地址"),
          ),

          SizedBox(height: 100),

          TextButton(
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(
                Size(double.infinity, 30),
              ),
            ),
            onPressed: () {
              Provider.of<HomeModel>(ctx, listen: false).isBindURL = false;
            },
            child: Text(
              "点击此处预览博客列表",
              style: Theme.of(ctx).textTheme.subtitle1,
            ),
          ),

          // TextField(),
        ],
      ),
    );
  }
}

class ModalInsideModal extends StatelessWidget {
  final bool reverse;

  ModalInsideModal({Key key, this.reverse = false}) : super(key: key);
  final FocusNode node = FocusNode();

  @override
  Widget build(BuildContext ctx) {
    Future.delayed(
      Duration(milliseconds: 200),
      () => FocusScope.of(ctx).requestFocus(node),
    );
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
            showSuccess("提交成功");
            Navigator.pop(ctx);
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
