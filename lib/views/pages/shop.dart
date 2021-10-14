import 'dart:convert';

import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/consts.dart';
import 'package:byfix/models/discount_products.dart';
import 'package:byfix/models/last_products.dart';
import 'package:byfix/models/section_title.dart';
import 'package:byfix/models/single_campaign.dart';
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

  Map campaigns = {};
  bool hasCampaigns = true;
  Future<dynamic> getCampaigns() async {
    campaigns = {};
    var data =
        await Provider.of<Functions>(context, listen: false).getCampaigns();
    var json = jsonDecode(data);
    if (json["data"].length == 0) {
      hasCampaigns = false;
    } else {
      for (int i = 0; i < json["data"].length; i++) {
        campaigns.addAll({
          i: {
            'id': json["data"][i]['id'],
            'title': json["data"][i]["baslik"],
            'gorsel': "$kApiImg/services/${json["data"][i]['gorsel']}",
          }
        });
      }
    }
  }

  Map discounts = {};
  bool hasDiscount = true;
  Future<dynamic> getDiscounts() async {
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
  }

  Map products = {};
  bool hasProducts = true;
  Future<dynamic> getProducts() async {
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
  }

  Future<void> syncPage() async {
    await Provider.of<Functions>(context, listen: false).getCategories();
    await getCampaigns();
    await getDiscounts();
    await getProducts();
    setState(() {});
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
          campaigns.isNotEmpty
              ? CarouselSlider(
                  options: CarouselOptions(
                    scrollPhysics: const ClampingScrollPhysics(),
                    enableInfiniteScroll: false,
                    height: 240,
                    initialPage: 0,
                    viewportFraction: .9,
                  ),
                  items: campaigns.entries.map((item) {
                    return SingleCampaign(
                      image: item.value['gorsel'],
                      id: item.value['id'],
                    );
                  }).toList(),
                )
              : hasCampaigns
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(title: "BYFIX ARAÇLARI"),
              CarouselSlider(
                options: CarouselOptions(
                  scrollPhysics: const ClampingScrollPhysics(),
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: .9,
                  height: 480,
                ),
                items: Provider.of<Functions>(context, listen: false)
                    .cars
                    .entries
                    .map((e) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 10,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      boxShadow: kBoxShadow,
                      color: Colors.white,
                      borderRadius: kBorderRadius,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 5,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.network(
                                "$kApiImg/product-category/${e.value["gorsel"]}",
                                width:
                                    (MediaQuery.of(context).size.width - 80) /
                                        2,
                              ),
                              Expanded(
                                child: Text(
                                  e.value["title"],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 320,
                          child: Column(
                            children: [1, 2, 3, 4]
                                .map(
                                  (e) => Container(
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1,
                                          color: kSecColor,
                                        ),
                                      ),
                                    ),
                                    height: 80,
                                    child: Row(
                                      children: [
                                        Image.network(
                                          "https://byfixstore.com/images/product/6302131860945.png",
                                          height: 60,
                                        ),
                                        const Expanded(
                                          child: Text(
                                            "Ürün Adı",
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
