import 'package:flutter/material.dart';

class PageButton extends StatelessWidget {
  final int page;
  final Function onPress;
  final String title;
  final int id;

  const PageButton({
    Key? key,
    required this.page,
    required this.onPress,
    required this.title,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: OutlinedButton(
        onPressed: () {
          onPress();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              page == id ? Theme.of(context).primaryColor : Colors.transparent),
          foregroundColor: MaterialStateProperty.all(
              page == id ? Colors.white : Colors.white.withOpacity(.5)),
          side: MaterialStateProperty.all(
            BorderSide(
              width: 1.0,
              style: BorderStyle.solid,
              color: page == id ? Theme.of(context).primaryColor : Colors.white.withOpacity(.3),
            ),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
