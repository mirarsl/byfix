import 'package:flutter/material.dart';

import '../consts.dart';

class SingleExpansion extends StatelessWidget {
  final String title;
  final Widget text;
  final IconData? icon;
  const SingleExpansion({
    Key? key,
    required this.title,
    required this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedTextColor: Colors.black,
      collapsedIconColor: Colors.black,
      textColor: kPriColor,
      iconColor: kPriColor,
      leading: icon != null
          ? Icon(
              icon,
            )
          : const SizedBox(),
      title: Text(title),
      expandedAlignment: Alignment.centerLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 25,
            top: 5,
            left: kSectionHorizontal - 5,
            right: kSectionHorizontal,
          ),
          child: text,
        ),
      ],
    );
  }
}
