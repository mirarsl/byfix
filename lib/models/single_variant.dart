import 'package:byfix/models/variant_option.dart';
import 'package:flutter/material.dart';

import 'consts.dart';

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
    var answerName = variants.asMap().values.where((element) {
      return element["id"] == answer;
    });
    // if (answerName.isNotEmpty) {
    //   print(answerName.toList()[0]["ozellik"]);
    // }
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
                      answerName.toList()[0]["ozellik"],
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
            height: 40,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: variants.asMap().entries.map((e) {
                return VariantOption(
                  name: e.value["ozellik"],
                  last: e.key + 1 == variants.length,
                  option: answer == e.value["id"],
                  length: variants.length,
                  onPress: () {
                    onPress(e.value["id"]);
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
