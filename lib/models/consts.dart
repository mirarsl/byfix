import 'package:flutter/material.dart';

const kPriColor = Color(0xFFC06437);
const kSecColor = Color(0xFF32353A);
const double kSectionHorizontal = 25.0;
const double kSectionVertical = 15.0;
const kSection = EdgeInsets.symmetric(
  vertical: kSectionVertical,
  horizontal: kSectionHorizontal,
);
final kBorderRadius = BorderRadius.circular(10);
final kBoxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(.15),
    spreadRadius: 0,
    offset: const Offset(0, 3),
    blurRadius: 10,
  ),
];
const double headerHeight = 140;
final kLogo = Image.asset("images/logo.png", height: 100);
const kInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(50),
  ),
  borderSide: BorderSide(
    width: .8,
    color: kSecColor,
  ),
);
const kInputStyle = TextStyle(
  fontSize: 14,
  height: .5,
);
