import 'dart:convert';
import 'dart:ui';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/consts.dart';
import 'package:byfix/models/product_details_page/add_cart.dart';
import 'package:byfix/models/product_details_page/product_picture.dart';
import 'package:byfix/models/product_details_page/single_comment.dart';
import 'package:byfix/models/product_details_page/single_expansion.dart';
import 'package:byfix/models/product_details_page/single_variant.dart';
import 'package:byfix/models/product_details_page/star_percent.dart';
import 'package:byfix/views/product_details/product_comments.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:interactiveviewer_gallery/hero_dialog_route.dart';
import 'package:interactiveviewer_gallery/interactiveviewer_gallery.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProductQuickLook extends StatefulWidget {
  final int id;
  final int discount;
  final String? sepetKey;
  const ProductQuickLook({
    Key? key,
    required this.id,
    this.sepetKey,
    this.discount = 0,
  }) : super(key: key);

  @override
  _ProductQuickLookState createState() => _ProductQuickLookState();
}

class _ProductQuickLookState extends State<ProductQuickLook> {
  final CarouselController _carouselController = CarouselController();

  bool _showBorder = false;

  int _current = 0;

  Map details = {};

  List pictures = [];
  bool noPictures = false;
  List allPicList = [];

  List variantPictures = [];
  List variants = [];
  bool hasVariant = true;
  Map? variantAnswers = {};
  Map<int, double> variantAddPrice = {};

  List comments = [];
  bool noComment = false;
  double starPoint = 0;
  List stars = [];
  Map starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  List matchedProducts = [];

  String? kargoKalan;

  Future<void> getDetails() async {
    try {
      details = {};
      var data = await Provider.of<Functions>(context, listen: false)
          .getProductDetails(widget.id);
      var json = jsonDecode(data);
      details = json["data"];
      allPicList.add("$kApiImg/product/${details["gorsel"]}");
      pictures = details["includes"]["pictures"];
      if (pictures.isEmpty) {
        noPictures = true;
      } else {
        for (var element in pictures) {
          allPicList.add("$kApiImg/product/${element["gorsel"]}");
        }
      }
      comments = details["includes"]["comments"];

      starPoint = 0;

      if (comments.isEmpty) {
        noComment = true;
      } else {
        for (var element in comments) {
          starPoint = starPoint + double.parse(element["yildiz"]);
          if (int.parse(element["yildiz"]) == 5) {
            starCounts[5]++;
          } else if (int.parse(element["yildiz"]) >= 4) {
            starCounts[4]++;
          } else if (int.parse(element["yildiz"]) >= 3) {
            starCounts[3]++;
          } else if (int.parse(element["yildiz"]) >= 2) {
            starCounts[2]++;
          } else if (int.parse(element["yildiz"]) >= 1) {
            starCounts[1]++;
            starCounts[1]++;
          }
        }

        starPoint = starPoint / comments.length;
        if (starPoint == 5) {
          stars = [1, 1, 1, 1, 1];
        } else if (starPoint >= 4) {
          stars = [1, 1, 1, 1, 0];
        } else if (starPoint >= 3) {
          stars = [1, 1, 1, 0, 0];
        } else if (starPoint >= 2) {
          stars = [1, 1, 0, 0, 0];
        } else if (starPoint >= 1) {
          stars = [1, 0, 0, 0, 0];
        }
      }

      if (details["variants"] != null) {
        variants = details["variants"];
        for (int i = 0; i < variants.length; i++) {
          variantAnswers![variants[i]["id"]] = null;
          variantAddPrice[variants[i]["id"]] = 0;
        }
      } else {
        hasVariant = false;
      }

      if (details['matched_products'] != null) {
        matchedProducts = details["matched_products"];
      }
      setState(() {});
    } finally {}
  }

  String sozlesme = "";
  Future<void> getDocument() async {
    try {
      var data = await Provider.of<Functions>(context, listen: false)
          .getFixedPageDetails(7);
      var json = jsonDecode(data);
      sozlesme = json["data"]["icerik"];
    } finally {}
  }

  List categoryItems = [];
  Future<void> getProductCategoryItems() async {
    try {
      var data = await Provider.of<Functions>(context, listen: false)
          .getProductCategoryItems(details['kat_id']);
      var json = jsonDecode(data);
      for (var category in json["data"]) {
        categoryItems.add(category);
      }
    } finally {}
  }

  Future<void> asyncPage() async {
    await getDetails();
    getProductCategoryItems();
    getDocument();
    final nowDate = DateTime.now();
    final lastDate =
        DateTime(nowDate.year, nowDate.month, nowDate.day, 20, 0, 0);
    final duration = nowDate.difference(lastDate);
    if (duration < Duration.zero) {
      if (duration.inMinutes < 0) {
        int minute = duration.inMinutes * -1;
        int saat = minute ~/ 60;
        minute = minute % 60;
        if (saat > 0) {
          kargoKalan = "$saat Saat ";
          if (minute > 0) {
            kargoKalan = "$kargoKalan$minute Dakika";
          }
        } else if (minute > 0) {
          kargoKalan = "$minute Dakika";
        }
      }
    }
  }

  @override
  void initState() {
    asyncPage();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var formatter =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 2);
    var formatterNo =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 0);
    double price = 0.0;
    double oldPrice = 0.0;
    if (details.isNotEmpty) {
      if (details["fiyat"] != null) {
        double addPrice = 0;
        if (variantAddPrice.isNotEmpty) {
          variantAddPrice.forEach((key, value) {
            addPrice += value;
          });
        }
        price = double.parse(details["fiyat"]) + addPrice - widget.discount;
      }
      if (details["eski_fiyat"] != "") {
        oldPrice = double.parse(details["eski_fiyat"]);
      }
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
      child: Stack(
        children: [
          SafeArea(
            child: ListView(
              physics: const ClampingScrollPhysics(),
              children: [
                (pictures.isNotEmpty || noPictures) ||
                        variantPictures.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.10),
                              spreadRadius: 0,
                              offset: const Offset(0, 50),
                              blurRadius: 50,
                            ),
                          ],
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(150),
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: kSectionVertical,
                        ),
                        height: MediaQuery.of(context).size.height - 550,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            variantPictures.isNotEmpty
                                ? Container(
                                    padding: const EdgeInsets.only(bottom: 35),
                                    child: CarouselSlider(
                                      carouselController: _carouselController,
                                      options: CarouselOptions(
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        scrollPhysics:
                                            const ClampingScrollPhysics(),
                                        viewportFraction: 1,
                                        height: 400,
                                        initialPage: 0,
                                        enableInfiniteScroll: false,
                                        aspectRatio: 16 / 9,
                                      ),
                                      items: variantPictures
                                          .map(
                                            (e) => ProductPicture(
                                              image: e,
                                              onPress: () {
                                                Navigator.of(context).push(
                                                  HeroDialogRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        InteractiveviewerGallery(
                                                      sources: variantPictures,
                                                      maxScale: 5,
                                                      onPageChanged: (dir) {
                                                        _carouselController
                                                            .jumpToPage(dir);
                                                      },
                                                      initIndex: variantPictures
                                                          .indexOf(e),
                                                      itemBuilder: (context,
                                                              index, status) =>
                                                          Image.network(
                                                        variantPictures[index],
                                                        fit: BoxFit.contain,
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      kPriColor),
                                                              strokeWidth: 2,
                                                              backgroundColor:
                                                                  kSecColor,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.only(bottom: 35),
                                    child: CarouselSlider(
                                      carouselController: _carouselController,
                                      options: CarouselOptions(
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        },
                                        scrollPhysics:
                                            const ClampingScrollPhysics(),
                                        viewportFraction: 1,
                                        height: 400,
                                        initialPage: 0,
                                        enableInfiniteScroll: false,
                                        aspectRatio: 16 / 9,
                                      ),
                                      items: allPicList
                                          .map(
                                            (e) => ProductPicture(
                                              image: e,
                                              onPress: () {
                                                Navigator.of(context).push(
                                                  HeroDialogRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        InteractiveviewerGallery(
                                                      sources: allPicList,
                                                      maxScale: 5,
                                                      onPageChanged: (dir) {
                                                        _carouselController
                                                            .jumpToPage(dir);
                                                      },
                                                      initIndex:
                                                          allPicList.indexOf(e),
                                                      itemBuilder: (context,
                                                              index, status) =>
                                                          Image.network(
                                                        allPicList[index],
                                                        fit: BoxFit.contain,
                                                        height: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      kPriColor),
                                                              strokeWidth: 2,
                                                              backgroundColor:
                                                                  kSecColor,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                            Positioned(
                              bottom: 15,
                              child: SizedBox(
                                width: 60,
                                child: ClipRRect(
                                  borderRadius: kBorderRadius,
                                  child: LinearProgressIndicator(
                                    minHeight: 5,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      kPriColor,
                                    ),
                                    backgroundColor: kSecColor,
                                    value: variantPictures.isEmpty
                                        ? noPictures
                                            ? 1
                                            : (1 / (pictures.length) * _current)
                                        : (1 /
                                            (variantPictures.length - 1) *
                                            _current),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SkeletonLoader(
                        builder: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(150),
                              bottomRight: Radius.circular(150),
                            ),
                            color: Colors.white,
                          ),
                          height: 480,
                        ),
                      ),
                variants.isNotEmpty
                    ? Column(
                        children: variants.map((e) {
                          return SingleVariant(
                            name: e["baslik"],
                            variants: e["options"],
                            answer: variantAnswers != null
                                ? variantAnswers![e["id"]]
                                : null,
                            onPress: (int id, int? vid, List? pictures) {
                              setState(() {
                                if (pictures != null) {
                                  variantPictures.clear();
                                  for (var pic in pictures) {
                                    variantPictures.add(
                                        "$kApiImg/product/${pic["gorsel"]}");
                                  }
                                  // variantPictures.addAll(allPicList);
                                } else {
                                  variantPictures.clear();
                                }

                                variantAnswers![e["id"]] = vid;
                                variantAddPrice[e["id"]] = double.parse(
                                  e["options"][id]["fiyat"].toString(),
                                );
                              });
                            },
                          );
                        }).toList(),
                      )
                    : hasVariant
                        ? SkeletonLoader(
                            builder: Container(
                              height: 200,
                              color: Colors.white,
                              margin: const EdgeInsets.symmetric(
                                vertical: kSectionVertical,
                              ),
                            ),
                          )
                        : const SizedBox(),
                const SizedBox(height: 200),
              ],
            ),
          ),
          details.isNotEmpty
              ? SlidingUpPanel(
                  minHeight: 200,
                  maxHeight: MediaQuery.of(context).size.height,
                  panel: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 8,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kSectionHorizontal,
                          ),
                          decoration: BoxDecoration(
                            color: kSecColor.withOpacity(.15),
                            borderRadius: kBorderRadius,
                          ),
                        ),
                        Container(
                          height: 82,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kSectionHorizontal,
                          ),
                          decoration: BoxDecoration(
                            border: _showBorder
                                ? const Border(
                                    bottom: BorderSide(
                                      width: 1,
                                      color: kPriColor,
                                    ),
                                  )
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 2),
                                width: double.infinity,
                                child: Text(
                                  Provider.of<Functions>(context, listen: false)
                                      .categories[int.parse(details["kat_id"])]
                                          ['title']
                                      .toString(),
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: kPriColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          details["baslik"],
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "#" + details["urun_kod"],
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    comments.isNotEmpty
                                        ? Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    starPoint > 3.0
                                                        ? LineIcons.starAlt
                                                        : LineIcons.starHalfAlt,
                                                    color: kPriColor,
                                                    size: 18,
                                                  ),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                    starPoint
                                                        .toStringAsFixed(1),
                                                    style: const TextStyle(
                                                      color: kPriColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                comments.length.toString() +
                                                    " Adet Oy",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Theme.of(context).canvasColor,
                          height: MediaQuery.of(context).size.height - 110,
                          child: ListView(
                            physics: const ClampingScrollPhysics(),
                            children: [
                              kargoKalan != null
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 30,
                                        horizontal: kSectionHorizontal,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: kBoxShadow,
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            LineIcons.truckMoving,
                                            color: kPriColor,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                text: "$kargoKalan",
                                                style: const TextStyle(
                                                  color: kPriColor,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                children: const [
                                                  TextSpan(
                                                    text:
                                                        " içerisinde sipariş verirsen",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: " yarın",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: " kargoda.",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Container(
                                margin: EdgeInsets.only(
                                  top: kargoKalan != null ? 10 : 0,
                                  bottom: 10,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: kBoxShadow,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    details['spot'] != ""
                                        ? SingleExpansion(
                                            title: "Açıklama",
                                            text: HtmlWidget(details["spot"]),
                                            icon: LineIcons.info,
                                          )
                                        : const SizedBox(),
                                    details["icerik"] != ""
                                        ? SingleExpansion(
                                            title: "Özellikler",
                                            text: HtmlWidget(details["icerik"]),
                                            icon: LineIcons.table,
                                          )
                                        : const SizedBox(),
                                    sozlesme != ""
                                        ? SingleExpansion(
                                            title:
                                                "Teslimat ve İade Sözleşmesi",
                                            text: HtmlWidget(sozlesme),
                                            icon: LineIcons.fileInvoice,
                                          )
                                        : const SizedBox(),
                                    details["ek_bilgi"] != ""
                                        ? SingleExpansion(
                                            title: "Ek Bilgi",
                                            text:
                                                HtmlWidget(details["ek_bilgi"]),
                                            icon: LineIcons.plus,
                                          )
                                        : const SizedBox(),
                                    comments.isNotEmpty
                                        ? SingleExpansion(
                                            title: "Değerlendirmeler",
                                            text: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Text(
                                                          starPoint
                                                              .toStringAsFixed(
                                                                  1),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 36,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 10,
                                                          ),
                                                          child: Row(
                                                            children: stars
                                                                .map(
                                                                  (e) => Icon(
                                                                    e == 1
                                                                        ? LineIcons
                                                                            .starAlt
                                                                        : LineIcons
                                                                            .star,
                                                                    color:
                                                                        kPriColor,
                                                                  ),
                                                                )
                                                                .toList(),
                                                          ),
                                                        ),
                                                        Text(
                                                          "${comments.length} Değerlendirme",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: kSectionVertical,
                                                        bottom:
                                                            kSectionVertical,
                                                        left:
                                                            kSectionHorizontal,
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children:
                                                            [5, 4, 3, 2, 1]
                                                                .map(
                                                                  (e) =>
                                                                      StarPercent(
                                                                    index: e,
                                                                    count:
                                                                        starCounts[
                                                                            e],
                                                                    length: comments
                                                                        .length,
                                                                  ),
                                                                )
                                                                .toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: kSectionVertical,
                                                  ),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    vertical: kSectionVertical,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          const Expanded(
                                                            child: Text(
                                                              "En Faydalı Değerlendirme",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                          MaterialButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                Provider.of<Functions>(
                                                                        context,
                                                                        listen:
                                                                            false)
                                                                    .customRoute(
                                                                  ProductComments(
                                                                    comments:
                                                                        comments,
                                                                    starPoint:
                                                                        starPoint,
                                                                    details:
                                                                        details,
                                                                    starCounts:
                                                                        starCounts,
                                                                    stars:
                                                                        stars,
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: Text(
                                                              "Tümü (${comments.length})",
                                                              style:
                                                                  const TextStyle(
                                                                color:
                                                                    kPriColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SingleComment(
                                                        comments: comments[0],
                                                        productId:
                                                            details["id"],
                                                        func: () {
                                                          setState(() {});
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            icon: LineIcons.comments,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 150)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          details.isNotEmpty
              ? Align(
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
                    child: Row(
                      mainAxisAlignment: price != 0
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        price != 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "${price % 1 == 0 ? formatterNo.format(price) : formatter.format(price)}₺",
                                        style: const TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      details["kdv"] == "1"
                                          ? Text(
                                              " +%${details["kdv_oran"]} KDV",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: kPriColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  ),
                                  oldPrice != 0
                                      ? Row(
                                          children: [
                                            Text(
                                              "${oldPrice % 1 == 0 ? formatterNo.format(oldPrice) : formatter.format(oldPrice)} ₺",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFFD2D2D2),
                                                fontWeight: FontWeight.w400,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              "${(oldPrice - price) % 1 == 0 ? formatterNo.format(oldPrice - price) + "₺ " : formatter.format(oldPrice - price) + "₺ \n"}İndirim",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: kPriColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),
                                ],
                              )
                            : const SizedBox(),
                        AddCart(
                          pid: details["id"],
                          status: price != 0 ? true : false,
                          onPress: () async {
                            bool variantStatus = true;
                            for (var variant in variantAnswers!.entries) {
                              if (variant.value == null) {
                                variantStatus = false;
                              }
                            }
                            double addPrice = 0;
                            if (variantAddPrice.isNotEmpty) {
                              variantAddPrice.forEach((key, value) {
                                addPrice += value;
                              });
                            }
                            if (variantStatus) {
                              dynamic returnStatus =
                                  await Provider.of<Functions>(context,
                                          listen: false)
                                      .addBasketItem(
                                json: details,
                                variants: variantAnswers!.isNotEmpty
                                    ? variantAnswers
                                    : null,
                                matched: widget.sepetKey,
                                price: price,
                                additional: addPrice,
                              );
                              if (returnStatus != false) {
                                await ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                    sizeSuccessIcon: 75,
                                    type: ArtSweetAlertType.success,
                                    title: "Sepete Eklendi",
                                    barrierColor: Colors.black.withOpacity(.7),
                                    text:
                                        "Seçtiğiniz ürün başarılı bir şekilde sepetinize eklendi.",
                                    confirmButtonText: "Tamam",
                                    confirmButtonColor: kPriColor,
                                    dialogElevation: 30,
                                  ),
                                );
                                Navigator.pop(context);
                              } else {
                                await ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                    sizeSuccessIcon: 75,
                                    type: ArtSweetAlertType.danger,
                                    title: "Sepete Eklenmedi",
                                    barrierColor: Colors.black.withOpacity(.7),
                                    text:
                                        "İndirimli ürünü daha önce sepetinize eklediniz.",
                                    confirmButtonText: "Tamam",
                                    confirmButtonColor: kPriColor,
                                    dialogElevation: 30,
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            } else {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  sizeSuccessIcon: 75,
                                  type: ArtSweetAlertType.danger,
                                  title: "Seçim Yapılmadı",
                                  barrierColor: Colors.black.withOpacity(.7),
                                  text:
                                      "Lütfen ürün özellikleri arasında seçiminizi yapınız.",
                                  confirmButtonText: "Tamam",
                                  confirmButtonColor: kPriColor,
                                  dialogElevation: 30,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
