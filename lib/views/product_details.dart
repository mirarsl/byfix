import 'dart:convert';
import 'dart:ui';

import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/app_bar.dart';
import 'package:byfix/models/consts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class ProductDetails extends StatefulWidget {
  final int id;
  const ProductDetails({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final ScrollController _scrollController = ScrollController();
  final CarouselController _carouselController = CarouselController();

  bool _hideAppBar = true;
  bool isScrollingDown = false;

  int _current = 0;

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

  Map details = {};
  List pictures = [];
  List variants = [];
  List comments = [];
  Future<void> getDetails() async {
    try {
      details = {};
      var data = await Provider.of<Functions>(context, listen: false)
          .getProductDetails(widget.id);
      var json = jsonDecode(data);
      details = json["data"];
      pictures = details["includes"]["pictures"];
      // comments = details["includes"]["comments"];
      // variants = details["variants"];
      setState(() {});
    } catch (e) {
      print(json);
    }
  }

  Future<void> asyncPage() async {
    await getDetails();
  }

  @override
  void initState() {
    initScroll();
    asyncPage();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        controller: _scrollController,
        hideAppBar: _hideAppBar,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
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
                  bottomRight: Radius.circular(150),
                ),
              ),
              margin: const EdgeInsets.symmetric(
                vertical: kSectionVertical,
              ),
              height: 400,
              child: pictures.isNotEmpty
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(bottom: 35),
                          child: CarouselSlider(
                            carouselController: _carouselController,
                            options: CarouselOptions(
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                              scrollPhysics: ClampingScrollPhysics(),
                              viewportFraction: 1,
                              height: 400,
                              initialPage: 0,
                              enableInfiniteScroll: false,
                              aspectRatio: 16 / 9,
                            ),
                            items: <Widget>[
                                  ProductPicture(
                                      image:
                                          "$kApiImg/product/${details["gorsel"]}"),
                                ] +
                                pictures
                                    .map(
                                      (e) => ProductPicture(
                                          image:
                                              "$kApiImg/product/${e["gorsel"]}"),
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
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  kPriColor,
                                ),
                                backgroundColor: kSecColor,
                                value: (1 / (pictures.length) * _current),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : SkeletonLoader(
                      builder: Container(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductPicture extends StatelessWidget {
  const ProductPicture({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      opacity: 0.15,
      color: kSecColor,
      offset: const Offset(0, 2),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Image.network(
              image,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
          borderRadius: kBorderRadius,
        ),
      ),
    );
  }
}
