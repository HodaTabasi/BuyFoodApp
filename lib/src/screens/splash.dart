import 'package:flutter/material.dart';
import 'package:foodapplication/src/helpers/screen_navigation.dart';
import 'package:foodapplication/src/screens/login.dart';
import 'package:foodapplication/src/widgets/custom_text.dart';
import 'package:foodapplication/src/widgets/loading.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      changeScreen(context, LoginScreen());
    });
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset("images/splach.jpeg",width: 400,height: 400,),
        ));
  }
}
