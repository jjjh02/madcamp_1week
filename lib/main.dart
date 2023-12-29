import 'package:flutter/material.dart';
import 'package:madcamp_1week/NavigationPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: "Login", home: NavigationPageWidget());
    //debugShowCheckedModeBanner: false,
    // initialRoute: "/login",
    // for test : home: SigninEnterNicknamePageWidget(),
  }
}