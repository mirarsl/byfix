import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../consts.dart';

class ProductPicture extends StatelessWidget {
  const ProductPicture({
    Key? key,
    required this.image,
    required this.onPress,
  }) : super(key: key);

  final String image;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
      opacity: 0.15,
      color: kSecColor,
      offset: const Offset(0, 2),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: MaterialButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                onPress();
              },
              child: Image.network(
                image,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(kPriColor),
                      strokeWidth: 2,
                      backgroundColor: kSecColor,
                    ),
                  );
                },
                height: 360,
                fit: BoxFit.contain,
              ),
            ),
          ),
          borderRadius: kBorderRadius,
        ),
      ),
    );
  }
}
