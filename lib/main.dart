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
        primaryColor: Color(0xFF000000),
      ),
      routes: {
        '/': (context) => RGB(),
        'rgb': (context) => RGB(),
      },
    );
  }
}
