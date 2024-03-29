import 'package:byfix/models/consts.dart';
import 'package:byfix/views/home.dart';
import 'package:byfix/views/login.dart';
import 'package:byfix/views/rgb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import 'controllers/functions.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Functions(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      overlayColor: kSecColor,
      overlayOpacity: .7,
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: kCircular,
        ),
      ),
      child: MaterialApp(
        initialRoute: '/login',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kPriColor,
          secondaryHeaderColor: kSecColor,
          canvasColor: const Color(0xfff5f5f5),
        ),
        // darkTheme: ThemeData(
        //   brightness: Brightness.dark,
        //   primaryColor: kPriColor,
        //   secondaryHeaderColor: kSecColor,
        //   canvasColor: const Color(0xFF474747),
        // ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (context) => const Login(),
          '/': (context) => const Home(),
          '/rgb': (context) => const RGB(),
        },
      ),
    );
  }
}
