import 'package:flutter/material.dart';

import '../consts.dart';

class VariantOption extends StatelessWidget {
  final bool option;
  final bool last;
  final String name;
  final int length;
  final Function onPress;
  final int addPrice;
  final String image;
  const VariantOption({
    Key? key,
    this.option = false,
    required this.last,
    required this.length,
    required this.name,
    required this.onPress,
    this.addPrice = 0,
    required this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        onPress();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: kBorderRadius,
          boxShadow: kBoxShadow,
          color: Colors.white,
          border: Border.all(
            width: option ? 2 : 1,
            color: option ? kPriColor : kSecColor,
          ),
        ),
        margin: EdgeInsets.only(right: last ? 0 : 10),
        width: MediaQuery.of(context).size.width / 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != ''
                ? Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: Image.network(
                      'https://byfixstore.com/images/product/$image',
                      height: 60,
                    ),
                  )
                : const SizedBox(),
            Center(
              child: RichText(
                text: TextSpan(
                  text: name,
                  style: const TextStyle(
                    fontSize: 14,
                    color: kSecColor,
                  ),
                  children: [
                    TextSpan(
                      text: addPrice != 0 ? "\n+$addPrice" : "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: kPriColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
