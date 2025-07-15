import 'package:flutter/material.dart';
import 'package:login_app/screens/HomeScreen/home_screen.dart';
import 'package:login_app/screens/SplashScreen/splash_screen.dart';
import 'package:login_app/screens/LoginScreen/loginScreen2.dart';

Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen2.routeName: (context) => LoginScreen2(),
  HomeScreen.routeName: (context) => HomeScreen()
};
