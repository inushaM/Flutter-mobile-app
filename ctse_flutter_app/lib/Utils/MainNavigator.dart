import 'package:flutter/material.dart';

//Home page navigator called by SplashScreen
class MainNavigator {
  static void goToHome(BuildContext context) {
    Navigator.pushNamed(context, "/home");
  }
}
