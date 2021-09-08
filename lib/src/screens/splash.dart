import 'package:flutter/material.dart';
import 'package:foodapplication/src/widgets/custom_text.dart';
import 'package:foodapplication/src/widgets/loading.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomText(text: "Loading"),
            Loading(),
          ],
        ));
  }
}
