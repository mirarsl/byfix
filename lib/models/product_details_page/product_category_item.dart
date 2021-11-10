import 'package:byfix/controllers/functions.dart';
import 'package:byfix/views/product_details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../consts.dart';

class ProductCategoryItems extends StatelessWidget {
  const ProductCategoryItems({
    Key? key,
    required this.oldPrice,
    required this.price,
    required this.image,
    required this.title,
    required this.category,
    required this.id,
  }) : super(key: key);

  final double oldPrice;
  final double price;
  final String image;
  final String title;
  final String category;
  final int id;

  @override
  Widget build(BuildContext context) {
    var formatter =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 2);
    var formatterNo =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 0);
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
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
          Navigator.of(context).pop();
          Navigator.of(context).push(
            Provider.of<Functions>(context, listen: false).customRoute(
              ProductDetails(id: id),
            ),
          );
        },
        child: Column(
          children: [
            Container(
              height: 200,
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
                      'https://byfixstore.com/images/product/$image',
                      height: 120,
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
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      Text(
                        price != 0
                            ? price % 1 == 0
                                ? formatterNo.format(price) + "₺"
                                : formatter.format(price) + "₺"
                            : "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        ),
                        textAlign: TextAlign.start,
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
