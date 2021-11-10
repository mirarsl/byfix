import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../consts.dart';

class AddCart extends StatelessWidget {
  final int pid;
  final bool status;
  final Function onPress;
  final String text;
  const AddCart({
    required this.pid,
    this.status = true,
    required this.onPress,
    this.text = "Sepete Ekle",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPress();
      },
      style: kButtonStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(status ? LineIcons.addToShoppingCart : LineIcons.bell),
          const SizedBox(width: 3),
          Text(status ? text : "Stokta Yok"),
        ],
      ),
    );
  }
}
