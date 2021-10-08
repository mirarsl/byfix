import 'package:byfix/models/consts.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  List<Widget> mainMenu = [
    ListTile(
      onTap: () {},
      leading: const Icon(Icons.home),
      title: const Text('Anasayfa'),
    ),
    ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      leading: const Icon(
        Icons.business,
        color: Colors.white,
      ),
      title: const Text(
        "Kurumsal",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      children: [
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('Hakkımızda'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('Misyon & Vizyon'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('Kavramlarımız'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('Ne - Neden Yapıyoruz'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('Hesap Numaralarımız'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('İnsan Kaynakları'),
        ),
      ],
    ),
    ExpansionTile(
      iconColor: Colors.white,
      collapsedIconColor: Colors.white,
      leading: const Icon(
        Icons.car_repair,
        color: Colors.white,
      ),
      title: const Text(
        "Ürünler",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      children: [
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('WOLKSWAGEN'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('NISSAN NAVARA'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('OUTDOOR'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text('FORD RANGER'),
        ),
        ListTile(
          onTap: () {},
          leading: const SizedBox(),
          title: const Text("ISUZU D'MAX"),
        ),
      ],
    ),
    ListTile(
      onTap: () {},
      leading: Icon(Icons.call),
      title: Text('İletişim'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListTileTheme(
        textColor: Colors.white,
        iconColor: Colors.white,
        selectedColor: kPriColor,
        child: Column(
          key: const Key('menu'),
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: 128.0,
              height: 128.0,
              margin: const EdgeInsets.only(
                top: 24.0,
                bottom: 24.0,
              ),
              decoration: const BoxDecoration(
                color: kPriColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'images/logo.png',
              ),
            ),
            Expanded(
              child: ListView(
                children: mainMenu,
              ),
            ),
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white54),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'KVKK',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white54),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Mesafeli Satış Sözleşmesi',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
