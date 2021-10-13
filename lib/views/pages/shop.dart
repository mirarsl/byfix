import 'package:byfix/models/consts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';

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
  // final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget._scrollController,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            scrollPhysics: const ClampingScrollPhysics(),
            enableInfiniteScroll: false,
            height: 240,
            initialPage: 0,
            viewportFraction: .9,
          ),
          items: [1, 2, 3, 4, 5]
              .map((item) => Container(
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
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: kBorderRadius,
                          ),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {
                        //TODO Kampanya Detayları
                      },
                      child: ClipRRect(
                        borderRadius: kBorderRadius,
                        child: Image.asset(
                          'images/kampanya.jpeg',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: kSection,
              child: Text(
                "İNDİRİMLİ ÜRÜNLER",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                scrollPhysics: const ClampingScrollPhysics(),
                initialPage: 0,
                enableInfiniteScroll: false,
                viewportFraction: .9,
                height: 220,
              ),
              items: [1, 2]
                  .map(
                    (e) => Container(
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
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 5,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.network(
                                    'https://byfixstore.com/images/product/1176771051209-586-part-2.png',
                                    width: 150,
                                    height: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Wolkswagen".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        "TAVAN SEPETİ".toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          overflow: TextOverflow.fade,
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            height: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "5.000",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      "₺",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Text(
                                      "6.000₺",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      "1.000₺" " " "İndirim",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor,
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
                  )
                  .toList(),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: kSection,
              child: Text(
                "SON ÜRÜNLER",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            CarouselSlider(
              options: CarouselOptions(
                scrollPhysics: const ClampingScrollPhysics(),
                initialPage: 0,
                enableInfiniteScroll: false,
                viewportFraction: .9,
                height: 500,
              ),
              items: [1, 2, 3, 4, 5, 6]
                  .map(
                    (e) => Container(
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
                            height: 380,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 5,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.network(
                                    'https://byfixstore.com/images/product/2821013102785-799.jpeg',
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  height: 55,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "OUTDOOR".toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "KAMP - BAHÇE KÜREĞİ".toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          overflow: TextOverflow.fade,
                                          fontSize: 14,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "6.000₺",
                                      style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "295",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      "₺",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
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
                  )
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }
}
