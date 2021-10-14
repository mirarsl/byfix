import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'network.dart';

class Functions with ChangeNotifier, DiagnosticableTreeMixin {
  Future<dynamic> getInfo() async {
    var data = await Network(url: "info").getData();
    return data;
  }

  Future<dynamic> getCampaigns() async {
    var data = await Network(url: "kampanya").getData();
    return data;
  }

  Map categories = {};
  Map cars = {};
  Future<dynamic> getCategories() async {
    categories = {};
    cars = {};
    var data = await Network(url: "categories").getData();
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
        }
      });
      if (json["data"][i]["anasayfa_grup"] != "0") {
        cars.addAll({
          json["data"][i]['id']: {
            'id': json["data"][i]['id'],
            'title': json["data"][i]["baslik"],
            'category': json["data"][i]["kat_id"],
            'anasayfa': json["data"][i]["anasayfa"],
            'anasayfa_grup': json["data"][i]["anasayfa_grup"],
            'grup_sira': json["data"][i]["grup_sira"],
            'gorsel': json["data"][i]['gorsel'],
            'icon': json["data"][i]['icon'],
          }
        });
      }
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
}
