import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'add_cart.dart';
import 'consts.dart';

class LastProducts extends StatelessWidget {
  final int id;
  final String image;
  final String title;
  final String category;
  final double price;
  final double oldPrice;
  const LastProducts({
    required this.id,
    required this.title,
    required this.image,
    required this.category,
    required this.price,
    this.oldPrice = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 0);
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
      child: MaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          print(id);
        },
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
                      image,
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
                          category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          title.toUpperCase(),
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
              height: 80,
              width: double.infinity,
              padding: const EdgeInsets.only(right: 25, left: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      oldPrice != 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  formatter.format(oldPrice),
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            price != 0 ? formatter.format(price) + "₺" : "",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(width: 2),
                          price != 0
                              ? const Text(
                                  "₺",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  AddCart(pid: id, status: price != 0 ? true : false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LastProductsSkeleton extends StatelessWidget {
  const LastProductsSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: SkeletonLoader(
        builder: Container(
          height: 500,
          margin: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          decoration: BoxDecoration(borderRadius: kBorderRadius),
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
                    Container(
                      height: 300,
                      color: Colors.white,
                    ),
                    Container(
                      height: 55,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 10,
                            width: double.infinity,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 120,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 10,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
