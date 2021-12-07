import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../consts.dart';

class CartSinglePrice extends StatelessWidget {
  const CartSinglePrice({
    required this.title,
    required this.price,
    this.kdv,
    Key? key,
  }) : super(key: key);

  final String title;
  final double price;
  final double? kdv;

  @override
  Widget build(BuildContext context) {
    var formatter =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 2);
    var formatterNo =
        NumberFormat.currency(locale: 'tr', symbol: '', decimalDigits: 0);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kSectionHorizontal),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 2.5),
          Row(
            children: [
              Text(
                price % 1 == 0
                    ? formatterNo.format(price) + "₺"
                    : formatter.format(price) + "₺",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              kdv != null
                  ? Text(
                      " +%${kdv!.toStringAsFixed(0)} KDV",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: kPriColor,
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
