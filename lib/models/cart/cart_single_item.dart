import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/cart/cart_item_button.dart';
import 'package:byfix/models/cart/cart_single_item_single_price.dart';
import 'package:byfix/models/consts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class CartSingleItem extends StatefulWidget {
  const CartSingleItem({
    required this.id,
    required this.sepetKey,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
    required this.syncPage,
    this.kdv,
    this.kargo,
    this.variants,
    Key? key,
  }) : super(key: key);

  final int id;
  final String sepetKey;
  final String image;
  final String title;
  final double price;
  final double? kdv;
  final double? kargo;
  final Map? variants;
  final int quantity;
  final Future<void> syncPage;

  @override
  State<CartSingleItem> createState() => _CartSingleItemState();
}

class _CartSingleItemState extends State<CartSingleItem> {
  Map variantAnswers = {};
  void variantControl() async {
    var data = await Provider.of<Functions>(context, listen: false)
        .getProductVariants(widget.id);
    var json = jsonDecode(data);
    List? allVariants = json["data"]["variants"];
    if (allVariants != null) {
      for (var data in allVariants) {
        List options = data["options"];
        List returned = options
            .where(
              (element) => element['id'] == widget.variants![data["id"]],
            )
            .toList();
        setState(() {
          variantAnswers[data['id']] = {
            'baslik': data['baslik'],
            'option': {
              'baslik': returned[0]["ozellik"],
              'gorsel': returned[0]["gorsel"],
              'fiyat': returned[0]["fiyat"],
            }
          };
        });
      }
    }
  }

  @override
  void initState() {
    if (widget.variants!.isNotEmpty) {
      variantControl();
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String kargoGun;
    final nowDate = DateTime.now();
    var lastDate = DateTime(nowDate.year, nowDate.month, nowDate.day + 3);
    if (lastDate.weekday == 6) {
      lastDate = lastDate.add(const Duration(days: 2));
    } else if (lastDate.weekday == 7) {
      lastDate = lastDate.add(const Duration(days: 1));
    } //Hafta sonu ise haftanın ilk gününe çekilir
    kargoGun = DateFormat('dd MMMM EEEE', 'tr-TR').format(lastDate);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: kSectionHorizontal,
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        boxShadow: kBoxShadow,
        color: Colors.white,
        borderRadius: kBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.white,
                  child: variantAnswers.isNotEmpty &&
                          variantAnswers[widget.variants!.entries.first.key]
                                  ["option"]["gorsel"] !=
                              ""
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image(
                            image: NetworkImage(
                              'https://byfixstore.com/images/product/${variantAnswers[widget.variants!.entries.first.key]["option"]["gorsel"]}',
                            ),
                            width: 100,
                            height: 100,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image(
                            image: NetworkImage(
                              'https://byfixstore.com/images/product/${widget.image}',
                            ),
                            width: 100,
                            height: 100,
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width - 150,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      variantAnswers.isNotEmpty
                          ? Container(
                              margin:
                                  const EdgeInsets.only(top: 2.5, bottom: 7.5),
                              child: Row(
                                children: variantAnswers.entries
                                    .toList()
                                    .map(
                                      (e) => Text(
                                        "${e.value['baslik']} : ${e.value["option"]['baslik']} ${e.value["option"]["fiyat"] != 0 ? '+' + e.value["option"]["fiyat"].toString() + '₺' : ''}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                          : const SizedBox(height: 7.5),
                      Text(
                        "En geç $kargoGun günü kargoda",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CartSinglePrice(
                  title: "Fiyat",
                  price: widget.price,
                  kdv: widget.kdv,
                ),
                widget.kargo != null
                    ? CartSinglePrice(
                        title: "Kargo",
                        price: widget.kargo!,
                      )
                    : const SizedBox(),
                Row(
                  children: [
                    CartItemButton(
                      child: Center(
                        child: RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              Provider.of<Functions>(context, listen: false)
                                  .minusQuantity(
                                widget.sepetKey,
                                widget.quantity == 1,
                              );
                              widget.syncPage;
                            });
                          },
                          child: widget.quantity > 1
                              ? const Icon(
                                  LineIcons.minus,
                                  size: 14,
                                  color: Colors.grey,
                                )
                              : const Icon(
                                  LineIcons.alternateTrash,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                    ),
                    CartItemButton(
                      child: Center(
                        child: Text(
                          "${widget.quantity}",
                          style: const TextStyle(
                            color: kPriColor,
                          ),
                        ),
                      ),
                      color: kPriColor,
                      size: 30,
                    ),
                    CartItemButton(
                      child: Center(
                        child: RawMaterialButton(
                          onPressed: () async {
                            bool status =
                                Provider.of<Functions>(context, listen: false)
                                    .plusQuantity(widget.sepetKey);
                            if (status == true) {
                              widget.syncPage;
                              setState(() {});
                            } else {
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  sizeSuccessIcon: 75,
                                  type: ArtSweetAlertType.danger,
                                  title: "Adet Arttırılamadı",
                                  barrierColor: Colors.black.withOpacity(.7),
                                  text:
                                      "Kampanya ile birlikte eklenen ürünlerde birden fazla alım gerçekleştirilemez.",
                                  confirmButtonText: "Tamam",
                                  confirmButtonColor: kPriColor,
                                  dialogElevation: 30,
                                ),
                              );
                            }
                          },
                          child: const Icon(
                            LineIcons.plus,
                            size: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
