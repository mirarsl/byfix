import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'category_product.dart';
import 'consts.dart';

class SingleCategory extends StatelessWidget {
  final String image;
  final String title;
  final List list;
  final int id;
  const SingleCategory({
    required this.title,
    required this.image,
    required this.list,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = 0;
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
      child: Column(
        children: [
          MaterialButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              print(id);
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 5,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.network(
                    "$kApiImg/product-category/${image}",
                    width: (MediaQuery.of(context).size.width - 80) / 2,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 320,
            child: list.isNotEmpty
                ? Column(
                    children: list
                        .sublist(0, list.length >= 4 ? 4 : list.length)
                        .map((e) {
                      i++;
                      return CategoryProduct(
                        i: i,
                        id: e['id'],
                        image: e["gorsel"],
                        baslik: e['baslik'],
                      );
                    }).toList(),
                  )
                : const Center(
                    child: Text("Bu kategoride ürün bulunamamıştır."),
                  ),
          ),
        ],
      ),
    );
  }
}

class SingleCategorySkeleton extends StatelessWidget {
  const SingleCategorySkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 70),
      child: SkeletonLoader(
        builder: Container(
          height: 480,
          margin: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            boxShadow: kBoxShadow,
            // color: Colors.white,
            borderRadius: kBorderRadius,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 120,
                    width: (MediaQuery.of(context).size.width - 80) / 2,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 120,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: MediaQuery.of(context).size.width - 150,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
