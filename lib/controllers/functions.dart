import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iyzico/iyzico.dart';

import 'network.dart';

class Functions with ChangeNotifier, DiagnosticableTreeMixin {
  int? _loggedUserID;
  String? _loggedUserName;
  String? _loggedUserSurname;
  String? _loggedUserPhone;
  String? _loggedUserEmail;
  String? _loggedUserTC;
  String? _loggedUserGender;
  String? _loggedUserIP;
  String? _loggedUserDate;
  String? _loggedUserLoginDate;

  get loggedUser {
    return {
      'id': _loggedUserID,
      'name': _loggedUserName,
      'surname': _loggedUserSurname,
      'phone': _loggedUserPhone,
      'email': _loggedUserEmail,
      'tc': _loggedUserTC,
      'gender': _loggedUserGender,
      'IP': _loggedUserIP,
      'date': _loggedUserDate,
      'login': _loggedUserLoginDate
    };
  }

  void setLoggedUser(
      id, name, surname, phone, email, tc, gender, ip, date, loginDate) {
    _loggedUserID = id;
    _loggedUserName = name;
    _loggedUserSurname = surname;
    _loggedUserPhone = phone;
    _loggedUserEmail = email;
    _loggedUserTC = tc;
    _loggedUserGender = gender;
    _loggedUserIP = ip;
    _loggedUserDate = date;
    _loggedUserLoginDate = loginDate;
    notifyListeners();
  }

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

  Future<dynamic> addBasketItem({
    var json,
    double? price,
    Map? variants,
    double? additional,
    String? matched,
  }) async {
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
        } //Birden fazla varyant kontrol edilir.
        sepetKey = md5
            .convert(
              utf8.encode(json["urun_kod"] + '/' + variantString),
            )
            .toString();
      }
    } //SEPET KEY BİTTİ

    if (variants != null) {
      for (var variant in variants.entries) {
        variantAnswers[variant.key] = variant.value;
      }
    } //VARYANTLAR EKLENDİ

    String urunKod = json["urun_kod"];
    int id = json["id"];
    String image = json["gorsel"];
    double? basketPrice;
    double fiyat = double.parse(json["fiyat"]);
    double? kdvOran = double.parse(json["kdv_oran"]);
    double kdvUcret = 0;
    String name = json["baslik"];
    String category = categories[int.parse(json["kat_id"])]["title"];

    if (price != null) {
      if (additional != null) {
        price += additional;
      }
      if (json["kargo"] == "1") {
        double kargoUcret = double.parse(json["kargo_ucret"]);
        price += kargoUcret;
      }
      if (json["kdv"] == "1") {
        kdvUcret = (price / 100) * kdvOran;
      }
      basketPrice = price;
    } else {
      if (additional != null) {
        fiyat += additional;
      }
      if (json["kargo"] == "1") {
        double kargoUcret = double.parse(json["kargo_ucret"]);
        fiyat += kargoUcret;
      }
      if (json["kdv"] == "1") {
        kdvUcret = (fiyat / 100) * kdvOran;
      }
      basketPrice = fiyat;
    }

    if (basket[sepetKey] != null) {
      if (price == null) {
        basket[sepetKey]["quantity"] = basket[sepetKey]["quantity"] + 1;
      } else {
        return false;
      }
    } else {
      basket[sepetKey] = {
        'id': id,
        'code': urunKod,
        'name': name,
        'image': image,
        'quantity': 1,
        'category': category,
        'price': basketPrice,
        'kdv': kdvUcret,
        'kdv_oran': kdvOran,
        'kargo': json["kargo"],
        'kargo_ucret': json["kargo_ucret"],
        'variants': variantAnswers,
        'additional': additional,
        'matched': matched
      };
    }
    notifyListeners();
    return sepetKey;
  }

  void minusQuantity(String key, bool erase) {
    if (erase) {
      basket.removeWhere((keys, value) {
        return value["matched"] == key;
      });
      basket.remove(key);
    } else {
      basket[key]["quantity"]--;
    }
    notifyListeners();
  }

  bool plusQuantity(String key) {
    if (basket[key]["matched"] == null) {
      basket[key]["quantity"]++;
    } else {
      return false;
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
    } finally {}
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

  Future<dynamic> getProductVariants(int id) async {
    var data = await Network(url: "products/$id", parameters: "variant=true")
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

  Future<dynamic> getSearch(term) async {
    var data = await Network(
      url: "search",
      parameters: "term=$term",
    ).getData();
    return data;
  }

  Future<dynamic> getLogin(email, password) async {
    var data = await Network(
      url: "user/login",
      parameters: "email=$email&password=$password",
    ).postData();
    return data;
  }
}
