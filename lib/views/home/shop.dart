import 'dart:convert';

import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/consts.dart';
import 'package:byfix/models/home_shop/discount_products.dart';
import 'package:byfix/models/home_shop/last_products.dart';
import 'package:byfix/models/home_shop/section_title.dart';
import 'package:byfix/models/home_shop/single_campaign.dart';
import 'package:byfix/models/home_shop/single_category.dart';
import 'package:byfix/models/home_shop/vertical_campaign.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
    Key? key,
    required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final ScrollController _scrollController;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String _loadingText = "Sürükle";

  void _onRefresh() async {
    context.loaderOverlay.show();
    await syncPage();
    _refreshController.refreshCompleted();
    context.loaderOverlay.hide();
  }

  Map horizontalCampaigns = {};
  bool hasHorizontalCampaigns = true;
  Future<dynamic> getHorizontalCampaigns() async {
    try {
      horizontalCampaigns = {};
      var data = await Provider.of<Functions>(context, listen: false)
          .getHorizontalCampaigns();
      var json = jsonDecode(data);
      if (json["data"].length == 0) {
        hasHorizontalCampaigns = false;
      } else {
        for (int i = 0; i < json["data"].length; i++) {
          horizontalCampaigns.addAll({
            i: {
              'id': json["data"][i]['id'],
              'title': json["data"][i]["baslik"],
              'gorsel': "$kApiImg/services/${json["data"][i]['gorsel']}",
            }
          });
        }
      }
    } finally {}
    setState(() {});
  }

  Map verticalCampaigns = {};
  bool hasVerticalCampaigns = true;
  Future<dynamic> getVerticalCampaigns() async {
    try {
      verticalCampaigns = {};
      var data = await Provider.of<Functions>(context, listen: false)
          .getVerticalCampaigns();
      var json = jsonDecode(data);
      if (json["data"].length == 0) {
        hasVerticalCampaigns = false;
      } else {
        for (int i = 0; i < json["data"].length; i++) {
          verticalCampaigns.addAll({
            i: {
              'id': json["data"][i]['id'],
              'title': json["data"][i]["baslik"],
              'gorsel': "$kApiImg/services/${json["data"][i]['gorsel']}",
            }
          });
        }
      }
    } finally {}
    setState(() {});
  }

  Map discounts = {};
  bool hasDiscount = true;
  Future<dynamic> getDiscounts() async {
    try {
      discounts = {};
      var data =
          await Provider.of<Functions>(context, listen: false).getDiscounts();
      var json = jsonDecode(data);
      if (json["data"].length == 0) {
        hasDiscount = false;
      } else {
        for (int i = 0; i < json["data"].length; i++) {
          discounts.addAll({
            i: {
              'id': json["data"][i]['id'],
              'title': json["data"][i]["baslik"],
              'category': Provider.of<Functions>(context, listen: false)
                  .categories[int.parse(json["data"][i]["kat_id"])]["title"],
              'image': "$kApiImg/product/${json["data"][i]['gorsel']}",
              'price': double.parse(json["data"][i]['fiyat']),
              'old_price': double.parse(json["data"][i]['eski_fiyat']),
            }
          });
        }
      }
    } finally {}
    setState(() {});
  }

  Map products = {};
  bool hasProducts = true;
  Future<dynamic> getProducts() async {
    try {
      products = {};
      var data =
          await Provider.of<Functions>(context, listen: false).getProducts();
      var json = jsonDecode(data);
      if (json["data"].length == 0) {
        hasProducts = false;
      } else {
        for (int i = 0; i < json["data"].length; i++) {
          products.addAll({
            i: {
              'id': json["data"][i]['id'],
              'title': json["data"][i]["baslik"],
              'category': Provider.of<Functions>(context, listen: false)
                  .categories[int.parse(json["data"][i]["kat_id"])]["title"],
              'image': "$kApiImg/product/${json["data"][i]['gorsel']}",
              'price': double.parse(json["data"][i]['fiyat']),
              'old_price': json["data"][i]['eski_fiyat'] != ""
                  ? double.parse(json["data"][i]['eski_fiyat'])
                  : 0.0
            }
          });
        }
      }
    } finally {}
    setState(() {});
  }

  Future<void> syncPage() async {
    await Provider.of<Functions>(context, listen: false).getCategories();
    getHorizontalCampaigns();
    getDiscounts();
    getVerticalCampaigns();
    getProducts();
  }

  @override
  void initState() {
    syncPage();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _onRefresh,
      enablePullUp: false,
      header: BezierHeader(
        onModeChange: (val) {
          if (val == RefreshStatus.canRefresh) {
            setState(() {
              _loadingText = "Yenilemek için sürüklemeyi bırak.";
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
        controller: widget._scrollController,
        children: [
          Container(
            padding: kSection,
            child: OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFC7C7C7)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                side: MaterialStateProperty.all(BorderSide.none),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {
                //TODO Arama sayfası yapılacak
              },
              child: Row(
                children: [
                  Icon(
                    LineIcons.search,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Arama Yapmak İçin Tıklayınız",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: .5,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          horizontalCampaigns.isNotEmpty
              ? CarouselSlider(
                  options: CarouselOptions(
                    scrollPhysics: const ClampingScrollPhysics(),
                    enableInfiniteScroll: false,
                    height: 230,
                    initialPage: 0,
                    viewportFraction: .9,
                  ),
                  items: horizontalCampaigns.entries.map((item) {
                    return SingleCampaign(
                      image: item.value['gorsel'],
                      id: item.value['id'],
                    );
                  }).toList(),
                )
              : hasHorizontalCampaigns
                  ? const SingleCampaignSkeleton()
                  : const SizedBox(),
          discounts.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: "İNDİRİMLİ ÜRÜNLER"),
                    CarouselSlider(
                      options: CarouselOptions(
                        scrollPhysics: const ClampingScrollPhysics(),
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        viewportFraction: .9,
                        height: 220,
                      ),
                      items: discounts.entries
                          .map(
                            (e) => DiscountProducts(
                              id: e.value['id'],
                              title: e.value['title'],
                              category: e.value['category'],
                              image: e.value['image'],
                              price: e.value['price'],
                              oldPrice: e.value['old_price'],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              : hasDiscount
                  ? const DiscountProductsSkeleton()
                  : const SizedBox(),
          verticalCampaigns.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: "KAMPANYALAR"),
                    CarouselSlider(
                      options: CarouselOptions(
                        scrollPhysics: const ClampingScrollPhysics(),
                        enableInfiniteScroll: false,
                        height: 400,
                        initialPage: 0,
                        viewportFraction: .9,
                      ),
                      items: verticalCampaigns.entries.map((item) {
                        return VerticalCampaign(
                          image: item.value['gorsel'],
                          id: item.value['id'],
                        );
                      }).toList(),
                    ),
                  ],
                )
              : hasVerticalCampaigns
                  ? const VerticalCampaignSkeleton()
                  : const SizedBox(),
          products.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: "SON ÜRÜNLER"),
                    CarouselSlider(
                      options: CarouselOptions(
                        scrollPhysics: const ClampingScrollPhysics(),
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        viewportFraction: .9,
                        height: 500,
                      ),
                      items: products.entries
                          .map(
                            (e) => LastProducts(
                              image: e.value["image"],
                              id: e.value["id"],
                              title: e.value["title"],
                              category: e.value["category"],
                              price: e.value["price"],
                              oldPrice: e.value["old_price"],
                            ),
                          )
                          .toList(),
                    ),
                  ],
                )
              : hasProducts
                  ? const LastProductsSkeleton()
                  : const SizedBox(),
          Provider.of<Functions>(context, listen: false).categories.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle(title: "KATEGORİLER"),
                    CarouselSlider(
                      options: CarouselOptions(
                        scrollPhysics: const ClampingScrollPhysics(),
                        initialPage: 0,
                        enableInfiniteScroll: false,
                        viewportFraction: .9,
                        height: 480,
                      ),
                      items: Provider.of<Functions>(context, listen: false)
                          .categories
                          .entries
                          .map((e) {
                        return SingleCategory(
                          image: e.value["icon"],
                          title: e.value["title"],
                          list: e.value["products"],
                          id: e.value["id"],
                        );
                      }).toList(),
                    ),
                  ],
                )
              : Provider.of<Functions>(context, listen: false).hasCategories
                  ? const SingleCategorySkeleton()
                  : const SizedBox(),
        ],
      ),
    );
  }
}
