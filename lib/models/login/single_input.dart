import 'package:flutter/material.dart';

class SingleInput extends StatelessWidget {
  final Function onChange;
  final String label;
  final bool type;
  final IconData icon;

  const SingleInput({
    required this.onChange,
    required this.label,
    required this.type,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isValidEmail(value) {
      return RegExp(
              r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(value);
    }

    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      margin: const EdgeInsets.only(top: 15),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Lütfen girilen bilgileri kontrol ediniz';
          }
          if (type == false) {
            if (!isValidEmail(value)) {
              return "Geçerli bir e-posta adresini giriniz";
            }
          }
          return null;
        },
        scrollPadding: EdgeInsets.zero,
        onChanged: (value) {
          onChange(value);
        },
        autocorrect: false,
        autofocus: false,
        obscureText: type,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(
              width: 1,
              color: Colors.white,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
          hintMaxLines: 1,
          hintText: label,
          hintStyle: const TextStyle(
            fontSize: 14,
            height: 1.75,
            color: Colors.white,
          ),
          focusColor: Colors.white,
          suffixIcon: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
          errorStyle: TextStyle(
            fontSize: 14,
          ),
        ),
        showCursor: false,
        style: const TextStyle(
          fontSize: 14,
          height: 2.25,
          color: Colors.white,
        ),
      ),
    );
  }
}
