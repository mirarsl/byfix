import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
        Container(
          margin: const EdgeInsets.only(top: 15),
          child: CarouselSlider(
            options: CarouselOptions(
              scrollPhysics: ClampingScrollPhysics(),
              height: 180,
              aspectRatio: 16 / 9,
              enableInfiniteScroll: false,
              initialPage: 0,
            ),
            //Kampanyalar
            items: [1, 2, 3, 4, 5].map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        elevation: MaterialStateProperty.all(0),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                      ),
                      onPressed: () {
                        print("a");
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        // padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              "https://bisu.com.tr/uploads/campaigns/612/file-1583408297032.jpg",
                            ),
                          ),
                        ),
                        child: null,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
