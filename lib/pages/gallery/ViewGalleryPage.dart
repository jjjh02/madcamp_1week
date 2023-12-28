import 'package:flutter/material.dart';

class ViewGalleryPageWidget extends StatefulWidget {
  const ViewGalleryPageWidget({super.key});

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
            child: Image.asset(images[index]),
            onTap: () {
              /*Navigator.push(context, MaterialPageRoute(builder: (_) {
                return DetailScreen(image: images[index]);
              }));*/
            },
          );
        },
      ),
    );
  }
}
