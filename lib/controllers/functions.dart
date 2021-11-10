import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iyzico/iyzico.dart';

import 'network.dart';

class Functions with ChangeNotifier, DiagnosticableTreeMixin {
  static const iyziConfig = IyziConfig(
    '90NH0oqaJ3G6IisETnmiH5EPzszC9Ibx',
    'Yhn7zJ4SWJ55VccuXk3EBjGaGNlWDGFw',
    'https://sandbox-api.iyzipay.com',
  );

  final iyzico = Iyzico.fromConfig(configuration: iyziConfig);

  // final paymentCard = PaymentCard(
  //   cardHolderName: 'John Doe',
  //   cardNumber: '5528790000000008',
  //   expireYear: '2030',
  //   expireMonth: '12',
  //   cvc: '123',
  // );
  //
  // final shippingAddress = Address(
  //   address: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
  //   contactName: 'Jane Doe',
  //   zipCode: '34742',
  //   city: 'Istanbul',
  //   country: 'Turkey',
  // );
  // final billingAddress = Address(
  //   address: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
  //   contactName: 'Jane Doe',
  //   city: 'Istanbul',
  //   country: 'Turkey',
  // );
  //
  // final buyer = Buyer(
  //   id: 'BY789',
  //   name: 'John',
  //   surname: 'Doe',
  //   identityNumber: '74300864791',
  //   email: 'email@email.com',
  //   registrationAddress: 'Nidakule Göztepe, Merdivenköy Mah. Bora Sok. No:1',
  //   city: 'Istanbul',
  //   country: 'Turkey',
  //   ip: '85.34.78.112',
  // );

  List<BasketItem> basketItems = <BasketItem>[];
  Map<String, dynamic> basket = {};

  Future<bool> addBasketItem(
      {var json, double? price, Map? variants, double? additional}) async {
    String sepetKey;
    Map variantAnswers = {};
    if (price == null && variants == null) {
      //Yalın ürün kodu
      sepetKey = md5.convert(utf8.encode(json["urun_kod"])).toString();
    } else {
      if (price != null) {
        //indirimi olan ürünün kodu varyant farketmez tek kullanımlıktır
        sepetKey = md5
            .convert(utf8.encode(json["urun_kod"] + '/' + price.toString()))
            .toString();
      } else {
        //indirimli olmayan ürün
        String variantString = "";

        for (var variant in variants!.entries) {
          variantString +=
              variant.key.toString() + '-' + variant.value.toString() + '/';
          variantAnswers[variant.key] = variant.value;
        } //Birden fazla varyant kontrol edilir.
        sepetKey = md5
            .convert(
              utf8.encode(json["urun_kod"] + '/' + variantString),
            )
            .toString();
      }
    }
    String urunKod = json["urun_kod"];
    int id = json["id"];
    double? basketPrice;
    double fiyat = double.parse(json["fiyat"]);
    double? kdvOran = double.parse(json["kdv_oran"]);
    double? kdvUcret;
    String name = json["baslik"];
    String category = categories[int.parse(json["kat_id"])]["title"];

    if (price != null) {
      if (additional != null) {
        price += additional;
      }
      if (json["kdv"] == "1") {
        kdvUcret = (price / 100) * kdvOran;
      }
      basketPrice = price;
    } else {
      if (additional != null) {
        fiyat += additional;
      }
      if (json["kdv"] == "1") {
        kdvUcret = (fiyat / 100) * kdvOran;
      }
      basketPrice = fiyat;
    }
    if (json["kargo"] == "1") {
      double kargoUcret = double.parse(json["kargo_ucret"]);
      basketPrice += kargoUcret;
    }

    if (basket[sepetKey] != null) {
      if (price == null) {
        // basket[sepetKey]["quantity"] = basket[sepetKey]["quantity"] + 1;
      } else {
        return false;
      }
    } else {
      basket[sepetKey] = {
        'id': id,
        'name': name,
        'quantity': 1,
        'price': basketPrice,
        'kdv': kdvUcret,
        'variants': variantAnswers,
        'additional': additional,
      };
    }
    notifyListeners();
    return true;
  }

  void createPayment() async {
    // final paymentResult = await iyzico.CreatePaymentRequest(
    //   price: 1.0,
    //   paidPrice: 1.1,
    //   paymentCard: paymentCard,
    //   buyer: buyer,
    //   shippingAddress: shippingAddress,
    //   billingAddress: billingAddress,
    //   basketItems: basketItems,
    // );
  }

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

  Future<dynamic> getFixedPages() async {
    var data = await Network(url: "pages").getData();
    return data;
  }

  Future<dynamic> getFixedPageDetails(int id) async {
    var data = await Network(url: "pages/$id").getData();
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
      parameters:
          "include=pictures|comments&variant=true&offset=0&limit=100&match=true",
    ).getData();
    return data;
  }

  Future<dynamic> getProductCategoryItems(id) async {
    var data = await Network(
      url: "categories/$id/products",
      parameters: "&limit=10&offset=0",
    ).getData();
    return data;
  }

  Future<dynamic> commentPoint(id, cid, type) async {
    var data = await Network(
      url: "products/$id/comments/$cid",
      parameters: "type=$type",
    ).postData();
    return data;
  }

  Future<dynamic> productComments(id, offset, limit) async {
    var data = await Network(
      url: "products/$id/comments/",
      parameters: "offset=$offset&limit=$limit",
    ).getData();
    return data;
  }
}
