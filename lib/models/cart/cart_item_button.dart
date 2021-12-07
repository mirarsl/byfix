import 'package:flutter/material.dart';

class CartItemButton extends StatelessWidget {
  const CartItemButton({
    Key? key,
    required this.child,
    this.size = 25,
    this.color = Colors.grey,
  }) : super(key: key);

  final Widget child;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
        border: Border.all(
          color: color,
          width: 1,
        ),
      ),
      width: size,
      height: size,
      child: child,
    );
  }
}
