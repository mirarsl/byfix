import 'package:byfix/controllers/functions.dart';
import 'package:byfix/views/product_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'add_cart.dart';
import 'consts.dart';

class DiscountProducts extends StatelessWidget {
  final int id;
  final String image;
  final String title;
  final String category;
  final double price;
  final double oldPrice;
  const DiscountProducts({
    required this.id,
    required this.image,
    required this.title,
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
          Navigator.of(context).push(
            Provider.of<Functions>(context, listen: false).customRoute(
              ProductDetails(id: id),
            ),
          );
        },
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
                      image,
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
                          category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 3),
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
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatter.format(price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(width: 2),
                          const Text(
                            "₺",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      oldPrice != 0
                          ? Row(
                              children: [
                                Text(
                                  "${formatter.format(oldPrice)}₺",
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  "${formatter.format(oldPrice - price)}₺ İndirim",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
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

class DiscountProductsSkeleton extends StatelessWidget {
  const DiscountProductsSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: SkeletonLoader(
        builder: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          height: 160,
          child: Row(
            children: [
              Container(
                color: Colors.white,
                height: double.infinity,
                width: 150,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 20,
                    width: MediaQuery.of(context).size.width - 230,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 20,
                    width: MediaQuery.of(context).size.width - 230,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 20,
                    width: MediaQuery.of(context).size.width - 230,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 20,
                    width: MediaQuery.of(context).size.width - 230,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
