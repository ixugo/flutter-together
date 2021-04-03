import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_together/app/bt.dart';
import 'package:flutter_together/app/control.dart';
import 'package:flutter_together/providers/app_state_model.dart';
import 'package:flutter_together/styles.dart';
import 'package:flutter_together/widgets/toast.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

final svgGirl = SvgPicture.asset(
  "assets/images/single_girl.svg",
  width: 150,
);
final infomation = SvgPicture.asset(
  "assets/images/information.svg",
  width: 150,
);
final blogAdd = SvgPicture.asset("assets/images/blog_add.svg", height: 200);

class ProductListTab extends StatelessWidget {
  _onPressed(context) {
    Future.delayed(
      Duration(milliseconds: 370),
      () => showAvatarModalBottomSheet(
        expand: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => ModalInsideModal(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        model.sctrl.addListener(() {
          if (model.sctrl.offset > 50) {
            model.setHeader(true);
          } else {
            model.setHeader(true);
          }
        });
        final products = model.getProducts();
        return CustomScrollView(
          semanticChildCount: products.length,
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: Colors.white.withOpacity(0),
              largeTitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Together",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  Visibility(
                    visible: !model.isHeader,
                    child: Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: InkWell(
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(
                              "https://img.golang.space/1617351635695-xu2yhH.jpg"),
                        ),
                        onTap: () {
                          showCupertinoModalBottomSheet(
                            expand: true,
                            context: context,
                            // elevation: 10,
                            // transitionBackgroundColor: Colors.yellow,
                            // barrierColor: Colors.grey,
                            backgroundColor: Colors.transparent,
                            builder: (context) => ModalWithNavigator(),
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
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == 0) {
                      return Container(
                        margin: EdgeInsets.only(top: 50),
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
                              onPressed: () => _onPressed(context),
                              child: Text("点此输入博客地址"),
                            ),

                            // TextField(),
                          ],
                        ),
                      );
                    }

                    // if (index < products.length) {
                    //   return ProductRowItem(
                    //     index: index,
                    //     product: products[index],
                    //     lastItem: index == products.length - 1,
                    //   );
                    // }

                    return null;
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class ProductRowItem extends StatelessWidget {
  const ProductRowItem({
    this.index,
    this.product,
    this.lastItem,
  });

  final Product product;
  final int index;
  final bool lastItem;

  @override
  Widget build(BuildContext context) {
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 16,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              product.assetName,
              package: product.assetPackage,
              fit: BoxFit.cover,
              width: 76,
              height: 76,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    style: Styles.productRowItemName,
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    '\$${product.price}',
                    style: Styles.productRowItemPrice,
                  )
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(
              CupertinoIcons.plus_circled,
              semanticLabel: 'Add',
            ),
            onPressed: () {
              final model = Provider.of<AppStateModel>(context);
              model.addProductToCart(product.id);
            },
          ),
        ],
      ),
    );

    if (lastItem) {
      return row;
    }

    return Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 100,
            right: 16,
          ),
          child: Container(
            height: 1,
            color: Styles.productRowDivider,
          ),
        ),
      ],
    );
  }
}

class ModalInsideModal extends StatelessWidget {
  final bool reverse;

  const ModalInsideModal({Key key, this.reverse = false}) : super(key: key);

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
                  autofocus: true,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
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
