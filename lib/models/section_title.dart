import 'package:flutter/material.dart';

import 'consts.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: kSection,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Image.asset(
            "images/kartal.png",
            height: 50,
          ),
        ],
      ),
    );
  }
}
