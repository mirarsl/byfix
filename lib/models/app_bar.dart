import 'package:flutter/material.dart';

import 'consts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hideAppBar;
  final List<Widget> actionList;
  final ScrollController controller;
  final Widget drawer;

  MyAppBar({
    required this.hideAppBar,
    required this.actionList,
    required this.controller,
    required this.drawer,
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: headerHeight,
      duration: const Duration(milliseconds: 300),
      child: AppBar(
        leading: drawer,
        title: kLogo,
        actions: actionList,
        toolbarHeight: 80,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.elliptical(
              120,
              120,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: kSecColor,
        shadowColor: Colors.black,
      ),
    );
  }
}