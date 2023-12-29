import 'package:flutter/material.dart';

class ViewGalleryPageWidget extends StatefulWidget {
  const ViewGalleryPageWidget({Key? key}) : super(key: key);

  @override
  State<ViewGalleryPageWidget> createState() => _ViewGalleryPageWidgetState();
}

class _ViewGalleryPageWidgetState extends State<ViewGalleryPageWidget> {
  final List<String> images = [
    'assets/image/image1.jpg',
    'assets/image/image2.jpg',
    'assets/image/image3.jpg',
    'assets/image/image4.jpg',
    'assets/image/image5.jpg',
    // ... 추가 이미지 경로
  ];

  void _showImageDialog(String imagePath) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // 배경을 투명하게 설정
        child: Stack(
          children: [
            Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.contain, // 이미지를 화면에 맞게 표시
                  ),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop(); // 닫기 버튼을 누르면 모달 닫기
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('갤러리'),
        
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              _showImageDialog(images[index]); // 이미지를 누르면 모달 다이얼로그 표시
            },
            child: Center(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.all(8.0), // 원하는 여백 설정
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}