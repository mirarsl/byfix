import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import '../consts.dart';

class VerticalCampaign extends StatelessWidget {
  final String image;
  final int id;

  const VerticalCampaign({
    required this.image,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 10,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: kBoxShadow,
        color: Colors.white,
        borderRadius: kBorderRadius,
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: kBorderRadius,
            ),
          ),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        onPressed: () {
          print(id.toString());
          //TODO Kampanya Detayları
        },
        child: ClipRRect(
          borderRadius: kBorderRadius,
          child: Image.network(
            image,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class VerticalCampaignSkeleton extends StatelessWidget {
  const VerticalCampaignSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      builder: Container(
        height: 400,
        margin: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          boxShadow: kBoxShadow,
          color: Colors.white,
          borderRadius: kBorderRadius,
        ),
      ),
    );
  }
}
