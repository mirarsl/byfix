import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../consts.dart';

class StarPercent extends StatelessWidget {
  const StarPercent({
    Key? key,
    required this.length,
    required this.count,
    required this.index,
  }) : super(key: key);

  final int length;
  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: Row(
        children: [
          const Icon(
            LineIcons.starAlt,
            color: kPriColor,
            size: 16,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Text(
              index.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          LinearPercentIndicator(
            width: 120,
            percent: (1 / length) * count,
            backgroundColor: Colors.grey.withOpacity(.5),
            progressColor: kPriColor,
          ),
          SizedBox(
            width: 20,
            child: Text(
              "$count",
              style: const TextStyle(
                fontSize: 12,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
