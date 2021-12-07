import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/consts.dart';
import 'package:byfix/views/product_details/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchItem extends StatelessWidget {
  final int id;
  final String title;
  final String image;
  final String? category;
  final int type;

  const SearchItem({
    required this.id,
    required this.title,
    required this.image,
    this.category,
    this.type = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: kSectionVertical,
        horizontal: kSectionHorizontal,
      ),
      height: 80,
      margin: const EdgeInsets.symmetric(
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: kBoxShadow,
      ),
      child: RawMaterialButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (type == 1) {
            Navigator.push(
              context,
              Provider.of<Functions>(context, listen: false).customRoute(
                ProductDetails(id: id),
              ),
            );
          } else {
            //TODO Kategori sayfasına
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(1.5),
              child: Image.network(
                'https://byfixstore.com/images/${type == 1 ? 'product' : 'product-category'}/$image',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  category != null
                      ? Text(
                          category!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    title,
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
