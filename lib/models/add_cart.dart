import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import 'consts.dart';

class AddCart extends StatelessWidget {
  final int pid;
  final bool status;
  const AddCart({
    required this.pid,
    this.status = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (status) {
          print("$pid Sepete Ekle");
        } else {
          print("Ürün için alarm");
        }
      },
      style: kButtonStyle,
      child: Row(
        children: [
          Icon(status ? LineIcons.addToShoppingCart : LineIcons.bell),
          Text(status ? "Sepete Ekle" : "Stokta Yok"),
        ],
      ),
    );
  }
}
