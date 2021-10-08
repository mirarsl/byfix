import 'package:byfix/models/consts.dart';
import 'package:byfix/views/home.dart';
import 'package:byfix/views/rgb.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: kPriColor,
        secondaryHeaderColor: kSecColor,
        canvasColor: const Color(0xffFFBDBDBD),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: kPriColor,
        secondaryHeaderColor: kSecColor,
        canvasColor: Color(0xffFF474747),
      ),
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const Home(),
        '/rgb': (context) => const RGB(),
      },
    );
  }
}
