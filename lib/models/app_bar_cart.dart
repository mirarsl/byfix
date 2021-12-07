import 'package:byfix/controllers/functions.dart';
import 'package:byfix/views/cart/cart_list.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'consts.dart';

class AppBarCart extends StatelessWidget {
  const AppBarCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          children: [
            IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context).push(
                  Provider.of<Functions>(context, listen: false).customRoute(
                    const CartList(),
                  ),
                );
              },
              icon: const Icon(
                LineIcons.shoppingCart,
                color: Colors.white,
              ),
            ),
            Provider.of<Functions>(context).basket.isNotEmpty
                ? Align(
                    child: Container(
                      child: Center(
                        child: Text(
                          Provider.of<Functions>(context)
                              .basket
                              .length
                              .toString(),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ),
                      height: 15,
                      width: 15,
                      decoration: const BoxDecoration(
                        color: kPriColor,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    alignment: Alignment.bottomRight.add(
                      const Alignment(-.4, -.4),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
