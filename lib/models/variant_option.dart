import 'package:flutter/material.dart';

import 'consts.dart';

class VariantOption extends StatelessWidget {
  final bool option;
  final bool last;
  final String name;
  final int length;
  final Function onPress;
  const VariantOption({
    Key? key,
    this.option = false,
    required this.last,
    required this.length,
    required this.name,
    required this.onPress,
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
        child: Center(
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: kSecColor,
            ),
          ),
        ),
      ),
    );
  }
}
