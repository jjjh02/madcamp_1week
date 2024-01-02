import 'package:flutter/material.dart';
import 'package:madcamp_1week/NavigationPage.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavigationPageWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFEF2E6),
      body: Center(
        child: Image.asset('assets/image/app_logo.png', width: 200, height: 200,), // 여기에 로고나 이미지를 추가할 수 있습니다.
      ),
    );
  }
}