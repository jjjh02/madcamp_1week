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
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/image/app_logo.png', width: 200, height: 200,),  
      Text("추억저장소", style: TextStyle(
    fontSize: 30.0, // 텍스트 크기를 20으로 설정
  ),),
      // 추가적인 자식 위젯들을 여기에 배치할 수 있습니다.
    ],
  ),
)
    );
  }
}

