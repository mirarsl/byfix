import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SlideSinglePrice extends StatelessWidget {
  const SlideSinglePrice({
    Key? key,
    required this.title,
    required this.kargoPrice,
    required this.formatterNo,
    required this.formatter,
  }) : super(key: key);

  final String title;
  final double kargoPrice;
  final NumberFormat formatterNo;
  final NumberFormat formatter;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          Text(
            "${kargoPrice % 1 == 0 ? formatterNo.format(kargoPrice) : formatter.format(kargoPrice)} ₺",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
