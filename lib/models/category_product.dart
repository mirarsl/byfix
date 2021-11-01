import 'package:byfix/controllers/functions.dart';
import 'package:byfix/views/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'consts.dart';

class CategoryProduct extends StatelessWidget {
  const CategoryProduct({
    Key? key,
    required this.i,
    required this.id,
    required this.image,
    required this.baslik,
  }) : super(key: key);

  final int i;
  final int id;
  final String image;
  final String baslik;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        Navigator.of(context).push(
          Provider.of<Functions>(context, listen: false).customRoute(
            ProductDetails(id: id),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: i != 4 ? kSecColor.withOpacity(.35) : Colors.transparent,
            ),
          ),
        ),
        height: 80,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                "$kApiImg/product/$image",
                width: 100,
              ),
            ),
            Container(
              height: double.infinity,
              width: 3.5,
              color: kPriColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: Text(
                  baslik,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
