import 'dart:convert';

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:byfix/controllers/functions.dart';
import 'package:byfix/models/consts.dart';
import 'package:byfix/models/login/single_input.dart';
import 'package:byfix/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:loader_overlay/src/overlay_controller_widget_extension.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  void credentialsControl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.remove('loggedUserEmail');
    // prefs.remove('loggedUserPassword');
    username = prefs.getString('loggedUserEmail');
    password = prefs.getString('loggedUserPassword');
    if (username != null && password != null) {
      getLogin();
    }
  }

  @override
  void initState() {
    credentialsControl();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? username;
  String? password;

  String error = "";
  String errorEmail = "";
  String errorPassword = "";

  bool saveCredentials = false;
  dynamic getLogin() async {
    context.loaderOverlay.show();
    try {
      var data = await Provider.of<Functions>(context, listen: false)
          .getLogin(username, password);
      var json = jsonDecode(data);
      if (json["data"] != null) {
        Provider.of<Functions>(context, listen: false).setLoggedUser(
          json["data"][0]['id'],
          json["data"][0]['isim'],
          json["data"][0]['soyisim'],
          json["data"][0]['telefon'],
          json["data"][0]['eposta'],
          json["data"][0]['tcno'],
          json["data"][0]['cinsiyet'],
          json["data"][0]['ip'],
          json["data"][0]['tarih'],
          json["created_at"],
        );
        if (saveCredentials) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('loggedUserEmail', username!);
          prefs.setString('loggedUserPassword', password!);
        }
        Navigator.push(
          context,
          Provider.of<Functions>(context, listen: false).customRoute(
            const Home(),
          ),
        );
      } else {
        if (json["error"] != null) {
          ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              title: 'Giriş Yapılamadı',
              text: json["error"],
              type: ArtSweetAlertType.danger,
            ),
          );
        } else if (json['message'] != null) {
          // print(json);
          ArtSweetAlert.show(
            context: context,
            artDialogArgs: ArtDialogArgs(
              title: 'Giriş Yapılamadı',
              text: json["message"],
              type: ArtSweetAlertType.danger,
            ),
          );
        }
      }
    } finally {}
    context.loaderOverlay.hide();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage('images/background.png'),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                spreadRadius: 0,
                offset: const Offset(0, 13),
                blurRadius: 10,
              ),
            ],
            color: Theme.of(context).canvasColor,
          ),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 160,
                    child: Image.asset('images/logo.png'),
                  ),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: const BoxDecoration(
                        color: Color(0x50D2D2D2),
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                      ),
                      child: const Icon(
                        LineIcons.user,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: kSectionHorizontal,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SingleInput(
                            onChange: (value) {
                              username = value;
                            },
                            label: 'Kullanıcı Adı',
                            type: false,
                            icon: LineIcons.user,
                          ),
                          Text(
                            errorEmail,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15, height: 1),
                          ),
                          SingleInput(
                            onChange: (value) {
                              password = value;
                            },
                            label: 'Şifre',
                            type: true,
                            icon: LineIcons.key,
                          ),
                          Text(
                            errorPassword,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15, height: 1),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kSectionHorizontal,
                            ),
                            child: CheckboxListTile(
                              title: const Text(
                                "Bilgilerimi Kaydet",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              value: saveCredentials,
                              activeColor: kPriColor,
                              onChanged: (bool? value) {
                                saveCredentials = value!;
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              fillColor: kPriColor,
                              textStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  ArtSweetAlert.show(
                                    context: context,
                                    artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.warning,
                                      title: "Giriş Yapılamadı",
                                      text: 'Lütfen tüm alanları doldurunuz',
                                      cancelButtonText: 'Tamam',
                                    ),
                                  );
                                } else {
                                  getLogin();
                                }
                              },
                              child: const Text("Giriş"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: kSectionHorizontal,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.all(
                                      Colors.transparent,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      Provider.of<Functions>(context,
                                              listen: false)
                                          .customRoute(
                                        const Home(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Kayıt olmak için tıklayınız",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
