import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'network.dart';

class Functions with ChangeNotifier, DiagnosticableTreeMixin {
  Route customRoute(Widget page) {
    return PageRouteBuilder(
      settings: const RouteSettings(name: 'FadeAnimation'),
      transitionDuration: const Duration(milliseconds: 50),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final Animation<double> _animation = CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
        );
        return FadeTransition(
          opacity: _animation,
          child: child,
        );
      },
    );
  }

  Future<dynamic> getInfo() async {
    var data = await Network(url: "info").getData();
    return data;
  }

  Future<dynamic> getHorizontalCampaigns() async {
    var data = await Network(url: "kampanya", parameters: "filter=0").getData();
    return data;
  }

  Future<dynamic> getVerticalCampaigns() async {
    var data = await Network(url: "kampanya", parameters: "filter=1").getData();
    return data;
  }

  Map categories = {};
  bool hasCategories = false;
  Future<dynamic> getCategories() async {
    try {
      categories = {};
      var data =
          await Network(url: "categories", parameters: "include=products")
              .getData();
      var json = jsonDecode(data);
      for (int i = 0; i < json["data"].length; i++) {
        categories.addAll({
          json["data"][i]['id']: {
            'id': json["data"][i]['id'],
            'title': json["data"][i]["baslik"],
            'category': json["data"][i]["kat_id"],
            'anasayfa': json["data"][i]["anasayfa"],
            'anasayfa_grup': json["data"][i]["anasayfa_grup"],
            'grup_sira': json["data"][i]["grup_sira"],
            'gorsel': json["data"][i]['gorsel'],
            'icon': json["data"][i]['icon'],
            'products': json["data"][i]['products'],
          }
        });
        hasCategories = true;
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<dynamic> getDiscounts() async {
    var data = await Network(url: "products/discounts").getData();
    return data;
  }

  Future<dynamic> getProducts() async {
    var data = await Network(url: "products", parameters: "offset=0&limit=10")
        .getData();
    return data;
  }

  Future<dynamic> getProductDetails(id) async {
    var data = await Network(
      url: "products/$id",
      parameters: "include=pictures|comments&variant=true&offset=0&limit=100",
    ).getData();
    return data;
  }
}
