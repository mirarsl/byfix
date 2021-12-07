import 'dart:async';

import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/app_bar.dart';
import 'package:byfix/models/cart/cart_single_item.dart';
import 'package:byfix/models/cart/cart_single_price.dart';
import 'package:byfix/models/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  final ScrollController _scrollController = ScrollController();

  bool _hideAppBar = true;
  bool isScrollingDown = false;
  double bottomSheetHeight = 0;

  initScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          setState(() {
            if (_scrollController.offset > 240) {
              isScrollingDown = true;
              _hideAppBar = false;
            }
          });
        }
      } else {
        if (isScrollingDown) {
          setState(() {
            isScrollingDown = false;
            _hideAppBar = true;
          });
        }
      }
    });
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String _loadingText = "Sürükle";

  void _onRefresh() async {
    await syncPage();
    setState(() {
      context.loaderOverlay.show();
      _refreshController.refreshCompleted();
      context.loaderOverlay.hide();
    });
  }

  double araTotalPrice = 0;
  double kdvPrice = 0;
  double totalPrice = 0;
  double kargoPrice = 0;
  Future<void> syncPage() async {
    araTotalPrice = 0;
    totalPrice = 0;
    kdvPrice = 0;
    kargoPrice = 0;
    for (var pd
        in Provider.of<Functions>(context, listen: false).basket.entries) {
      araTotalPrice += (pd.value["price"] * pd.value["quantity"]);
      kdvPrice += (pd.value["kdv"] * pd.value["quantity"]);
      if (pd.value["kargo"] == "1") {
        kargoPrice += double.parse(pd.value["kargo_ucret"]);
      }
    }
    totalPrice = araTotalPrice + kdvPrice + kargoPrice;
  }

  @override
  void initState() {
    initScroll();
    syncPage();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(Provider.of<Functions>(context).basket);
    var formatter =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 2);
    var formatterNo =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 0);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        controller: _scrollController,
        hideAppBar: _hideAppBar,
        actionList: const [
          // false
          //     ? Center(
          //         child: MaterialButton(
          //           highlightColor: Colors.transparent,
          //           splashColor: Colors.transparent,
          //           onPressed: () {},
          //           padding: EdgeInsets.zero,
          //           minWidth: 0,
          //           child: SizedBox(
          //             width: 40,
          //             height: 40,
          //             child: Container(
          //               decoration: const BoxDecoration(
          //                 color: Color(0x50D2D2D2),
          //                 borderRadius: BorderRadius.all(Radius.circular(20)),
          //               ),
          //               child: Center(
          //                 child: Text(
          //                   "BA",
          //                   style: const TextStyle(
          //                     color: Colors.white,
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     : const SizedBox(),
          SizedBox(width: 35),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    spreadRadius: 0,
                    offset: const Offset(0, 13),
                    blurRadius: 10,
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: kSectionHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sepetim",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: kSecColor,
                      ),
                    ),
                    const SizedBox(height: 7.5),
                    Text(
                      Provider.of<Functions>(context).basket.isNotEmpty
                          ? Provider.of<Functions>(context)
                                  .basket
                                  .length
                                  .toString() +
                              " ürün"
                          : "Sepetinizde ürün yok.",
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Stack(
                    children: [
                      SmartRefresher(
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        enablePullUp: false,
                        header: BezierHeader(
                          onModeChange: (val) {
                            if (val == RefreshStatus.canRefresh) {
                              setState(() {
                                _loadingText =
                                    "Yenilemek için sürüklemeyi bırak.";
                              });
                            } else if (val == RefreshStatus.refreshing) {
                              setState(() {
                                _loadingText = "Yenileniyor";
                              });
                            } else if (val == RefreshStatus.idle) {
                              setState(() {
                                _loadingText = "Sürükle";
                              });
                            } else if (val == RefreshStatus.completed) {
                              setState(() {
                                _loadingText = "Yenilendi";
                              });
                            }
                          },
                          child: Center(
                            child: Text(
                              _loadingText.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                letterSpacing: 1.5,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          rectHeight: 50,
                        ),
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 100),
                          controller: _scrollController,
                          physics: const ClampingScrollPhysics(),
                          children: [
                            Provider.of<Functions>(context).basket.isNotEmpty
                                ? Column(
                                    children: Provider.of<Functions>(context)
                                        .basket
                                        .entries
                                        .map(
                                      (e) {
                                        return CartSingleItem(
                                          syncPage: syncPage(),
                                          sepetKey: e.key,
                                          quantity: e.value["quantity"],
                                          id: e.value["id"],
                                          image: e.value["image"],
                                          title: e.value["name"],
                                          price: e.value["price"],
                                          variants: e.value["variants"],
                                          kdv: e.value["kdv"] != null
                                              ? e.value["kdv_oran"]
                                              : null,
                                          kargo: e.value["kargo"] == 1
                                              ? double.parse(
                                                  e.value["kargo_ucret"])
                                              : null,
                                        );
                                      },
                                    ).toList(),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        color: bottomSheetHeight == 300
                            ? Colors.black.withOpacity(.5)
                            : Colors.transparent,
                        duration: const Duration(milliseconds: 250),
                        height: bottomSheetHeight == 0
                            ? 0
                            : MediaQuery.of(context).size.height,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedContainer(
                      height: bottomSheetHeight,
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        boxShadow: kBoxShadow,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(
                            75,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 50.0,
                          left: 25,
                          right: 25,
                          bottom: 100,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SlideSinglePrice(
                                title: 'Kargo',
                                kargoPrice: kargoPrice,
                                formatterNo: formatterNo,
                                formatter: formatter,
                              ),
                              SlideSinglePrice(
                                title: 'KDV',
                                kargoPrice: kdvPrice,
                                formatterNo: formatterNo,
                                formatter: formatter,
                              ),
                              SlideSinglePrice(
                                title: 'Ürünler',
                                kargoPrice: araTotalPrice,
                                formatterNo: formatterNo,
                                formatter: formatter,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                width: double.infinity,
                                height: 2,
                                color: kPriColor,
                              ),
                              SlideSinglePrice(
                                title: 'TOPLAM',
                                kargoPrice: totalPrice,
                                formatterNo: formatterNo,
                                formatter: formatter,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        boxShadow: kBoxShadow,
                        color: kSecColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: kSectionHorizontal,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Toplam",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "${totalPrice % 1 == 0 ? formatterNo.format(totalPrice) : formatter.format(totalPrice)}₺",
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    if (bottomSheetHeight == 0) {
                                      bottomSheetHeight = 300;
                                    } else if (bottomSheetHeight == 300) {
                                      bottomSheetHeight = 0;
                                    }
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    LineIcons.angleUp,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                )
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: kButtonStyle,
                              child: const Text(
                                "Alışverişi Tamamla",
                                style: TextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
