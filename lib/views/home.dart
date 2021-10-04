import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text("BYFIX TEST"),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/rgb');
                },
                child: Text("RGB"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
