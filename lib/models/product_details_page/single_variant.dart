import 'package:byfix/models/product_details_page/variant_option.dart';
import 'package:flutter/material.dart';

import '../consts.dart';

class SingleVariant extends StatelessWidget {
  final String name;
  final List variants;
  final int? answer;
  final Function onPress;
  const SingleVariant({
    Key? key,
    required this.name,
    required this.variants,
    this.answer,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String answerName = "";

    if (answer != null) {
      var newL = variants.where((element) => element['id'] == answer);
      answerName = newL.toList()[0]['ozellik'];
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: kSectionHorizontal,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name.toUpperCase() + ":",
                style: const TextStyle(
                  color: kPriColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 3),
              answer != null
                  ? Text(
                      answerName,
                      style: const TextStyle(
                        color: kSecColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: kSectionVertical,
            ),
            height: 100,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: variants.asMap().entries.map((e) {
                return VariantOption(
                  name: e.value["ozellik"],
                  image: e.value["gorsel"],
                  addPrice: e.value['fiyat'],
                  last: e.key + 1 == variants.length,
                  option: answer == e.value["id"],
                  length: variants.length,
                  onPress: () {
                    List pictures = [];
                    if (e.value['gorsel'] != "") {
                      pictures.add(
                        {'gorsel': e.value['gorsel']},
                      );
                    }
                    pictures.addAll(e.value['pictures']);
                    onPress(e.key, e.value["id"], pictures);
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
