import 'dart:convert';

import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/app_bar.dart';
import 'package:byfix/models/consts.dart';
import 'package:byfix/models/product_details_page/single_comment.dart';
import 'package:byfix/models/product_details_page/star_percent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProductComments extends StatefulWidget {
  const ProductComments({
    required this.comments,
    required this.starPoint,
    required this.details,
    required this.starCounts,
    required this.stars,
    Key? key,
  }) : super(key: key);

  final List comments;
  final double starPoint;
  final Map details;
  final Map starCounts;
  final List stars;

  @override
  _ProductCommentsState createState() => _ProductCommentsState();
}

class _ProductCommentsState extends State<ProductComments> {
  List comments = [];
  Future<void> getComments() async {
    comments = [];
    try {
      var data = await Provider.of<Functions>(context, listen: false)
          .productComments(widget.details["id"], 0, 10);
      var json = jsonDecode(data);
      comments = json["data"];
      setState(() {});
    } finally {}
  }

  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  int offset = 10;
  void _onLoading() async {
    try {
      var data = await Provider.of<Functions>(context, listen: false)
          .productComments(widget.details["id"], offset, 10);
      var json = jsonDecode(data);
      if (json['status'] != 404) {
        comments += json["data"];
        offset += 10;
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
    } finally {}
    setState(() {});
  }

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

  void loadPage() async {
    await getComments();
  }

  @override
  void initState() {
    initScroll();
    loadPage();
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
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: kSectionHorizontal,
          vertical: kSectionVertical,
        ),
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          enablePullDown: false,
          onLoading: _onLoading,
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus? mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = const Text("Sürükle");
              } else if (mode == LoadStatus.loading) {
                body = kCircular;
              } else if (mode == LoadStatus.failed) {
                body = const Text("Hata");
              } else if (mode == LoadStatus.canLoading) {
                body = const Text("Yüklemek için bırak");
              } else {
                body = const Text("Daha fazla yorum bulunamadı");
              }
              return SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: body,
                ),
              );
            },
          ),
          child: ListView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.starPoint.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            child: Row(
                              children: widget.stars
                                  .map(
                                    (e) => Icon(
                                      e == 1
                                          ? LineIcons.starAlt
                                          : LineIcons.star,
                                      color: kPriColor,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          Text(
                            "${widget.comments.length} Değerlendirme",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          top: kSectionVertical,
                          bottom: kSectionVertical,
                          left: kSectionHorizontal,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [5, 4, 3, 2, 1]
                              .map(
                                (e) => StarPercent(
                                  index: e,
                                  count: widget.starCounts[e],
                                  length: widget.comments.length,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: const [
                      Icon(LineIcons.infoCircle),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Değerlendirme yapabilmeniz için ürünü satın almış olmanız gerekmektedir.",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: kSectionVertical,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: kPriColor,
                          width: 2,
                        ),
                      ),
                    ),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(Provider.of<Functions>(context, listen: false)
                            .categories[int.parse(widget.details["kat_id"])]
                                ['title']
                            .toString()),
                        Text(
                          widget.details['baslik'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  comments.isNotEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: kSectionVertical,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: comments.map((e) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                child: SingleComment(
                                  comments: e,
                                  productId: widget.details["id"],
                                  func: () {
                                    setState(() {});
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : const SingleCommentSkeleton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
