import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts.dart';

class SingleComment extends StatelessWidget {
  final Map comments;
  final int productId;

  const SingleComment({
    required this.comments,
    required this.productId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dateFormat = DateFormat('dd MMMM y', 'tr');
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E5E5),
                    borderRadius: BorderRadius.circular(
                      25,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${comments['isim'][0]}${comments['soyisim'][0]}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Text(
                        "${comments["gizli"] == "0" ? comments["isim"] : comments["isim"].toString().replaceRange(1, comments["isim"].toString().length, '*' * comments["isim"].toString().length)} ${comments["soyisim"].toString().replaceRange(
                              1,
                              comments["soyisim"].toString().length,
                              '*' * comments["soyisim"].toString().length,
                            )}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Row(
                      children: [1, 2, 3, 4, 5].map((e) {
                        return Icon(
                          int.parse(comments["yildiz"]) >= e
                              ? LineIcons.starAlt
                              : LineIcons.star,
                          color: kPriColor,
                        );
                      }).toList(),
                    )
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                dateFormat.format(
                  DateTime.parse(
                    comments["tarih"],
                  ),
                ),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        Container(
          child: Text(
            comments["yorum"],
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          decoration: BoxDecoration(
            color: const Color(
              0xFFE5E5E5,
            ),
            borderRadius: kBorderRadius,
          ),
          margin: const EdgeInsets.only(
            top: 20,
            bottom: 10,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
        ),
        Row(
          children: [
            CommentPointButton(
              count: comments["beneficial"],
              type: 0,
              productId: productId,
              commentId: comments["id"],
            ),
            CommentPointButton(
              count: comments["useless"],
              type: 1,
              commentId: comments["id"],
              productId: productId,
            ),
          ],
        ),
      ],
    );
  }
}

class CommentPointButton extends StatelessWidget {
  const CommentPointButton({
    Key? key,
    required this.count,
    required this.type,
    required this.productId,
    required this.commentId,
  }) : super(key: key);

  final int count;
  final int type;
  final int productId;
  final int commentId;

  @override
  Widget build(BuildContext context) {
    Future<bool> _getPref() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool value = prefs.getBool('comment-$commentId') ?? false;
      return value;
    }

    return MaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      minWidth: 0,
      onPressed: () async {
        // Provider.of<Functions>(context, listen: false).commentPoint(productId, commentId, type);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('comment-$commentId', true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Geri bildiriminiz için teşekkürler',
              textAlign: TextAlign.center,
            ),
            backgroundColor: kSecColor,
            duration: Duration(milliseconds: 1000),
            padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal: kSectionHorizontal,
            ),
          ),
        );
        //TODO verilen oylar hesaba taşınacak //Eğer giriş yapılmadıysa kapatılacak
      },
      child: Row(
        children: [
          Icon(
            type == 0 ? LineIcons.thumbsUp : LineIcons.thumbsDown,
            color: const Color(0xFF9E9E9E),
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            "${type == 0 ? 'Yararlı' : 'Yararısz'} ($count)",
            style: const TextStyle(
              color: Color(0xFF9E9E9E),
            ),
          ),
        ],
      ),
    );
  }
}
