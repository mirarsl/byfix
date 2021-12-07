import 'dart:async';
import 'dart:convert';

import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/app_bar.dart';
import 'package:byfix/models/consts.dart';
import 'package:byfix/models/search/search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final ScrollController _scrollController = ScrollController();

  bool _hideAppBar = true;
  bool isScrollingDown = false;

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

  bool hasValue = true;
  String searchValue = "";
  List searchedProducts = [];
  List searchedCategories = [];

  void clearSearch() {
    hasValue = true;
    searchedProducts = [];
    searchedCategories = [];
  }

  Future<void> getSearch() async {
    try {
      if (searchValue != "") {
        var data = await Provider.of<Functions>(context, listen: false)
            .getSearch(searchValue);
        var json = jsonDecode(data);
        List products = json['data']["products"];
        List categories = json['data']["categories"];
        if (products.isNotEmpty) {
          if (searchedProducts.isEmpty) {
            for (var product in json["data"]["products"]) {
              searchedProducts.add(product);
            }
          }
          hasValue = true;
        }
        if (categories.isNotEmpty) {
          if (searchedCategories.isEmpty) {
            for (var category in json["data"]["categories"]) {
              searchedCategories.add(category);
            }
          }
          hasValue = true;
        }
        if (products.isEmpty && categories.isEmpty) {
          hasValue = false;
        }
      } else {
        hasValue = false;
      }
    } finally {}
    setState(() {});
  }

  Future<void> syncPage() async {
    clearSearch();
    await getSearch();
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
                    SizedBox(
                      height: 40,
                      child: TextField(
                        scrollPadding: EdgeInsets.zero,
                        onChanged: (value) async {
                          setState(() {
                            searchValue = value;
                            clearSearch();
                            syncPage();
                          });
                        },
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: kPriColor,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          hintText: 'Ürün veya kategori ara',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            height: 1.75,
                            color: Colors.grey,
                          ),
                          focusColor: kPriColor,
                          suffixIcon: Icon(
                            LineIcons.search,
                            color: kPriColor,
                            size: 22,
                          ),
                        ),
                        showCursor: false,
                        style: const TextStyle(
                          fontSize: 14,
                          height: 2.25,
                        ),
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
                          padding: const EdgeInsets.only(top: 20, bottom: 5),
                          controller: _scrollController,
                          physics: hasValue
                              ? const ClampingScrollPhysics()
                              : const NeverScrollableScrollPhysics(),
                          children: searchedProducts.isNotEmpty ||
                                  searchedCategories.isNotEmpty
                              ? searchedProducts
                                      .map(
                                        (e) => SearchItem(
                                          title: "${e["baslik"]}",
                                          image: e['gorsel'],
                                          id: e["id"],
                                          category:
                                              Provider.of<Functions>(context)
                                                          .categories[
                                                      int.parse(e["kat_id"])]
                                                  ["title"],
                                        ),
                                      )
                                      .toList() +
                                  searchedCategories
                                      .map(
                                        (e) => SearchItem(
                                          id: e["id"],
                                          title: "Tüm Ürünler",
                                          image: e["gorsel"],
                                          type: 2,
                                          category: e["baslik"],
                                        ),
                                      )
                                      .toList()
                              : [
                                  hasValue
                                      ? SkeletonLoader(
                                          builder: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          items: 10,
                                        )
                                      : Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: kSectionVertical,
                                            horizontal: kSectionHorizontal,
                                          ),
                                          child: Center(
                                            child: searchValue != ""
                                                ? const Text("Ürün Bulunamadı")
                                                : const Text("Arama yapılmadı"),
                                          ),
                                        ),
                                ],
                        ),
                      ),
                    ],
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
