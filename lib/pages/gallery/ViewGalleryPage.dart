import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ViewGalleryPageWidget extends StatefulWidget {
  @override
  _ViewGalleryPageWidgetState createState() => _ViewGalleryPageWidgetState();
}

class _ViewGalleryPageWidgetState extends State<ViewGalleryPageWidget> {
  File? _image;
  List<File> imageFiles = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    setState(() {
      imageFiles = Directory(path)
          .listSync()  // 동기적으로 디렉토리 읽기
          .map((item) => File(item.path))
          .where((item) => item.path.endsWith('.png') || item.path.endsWith('.jpg'))
          .toList();
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      
      // 저장할 경로 찾기
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      final fileName = basename(imageFile.path);
      final File localImage = await imageFile.copy('$path/$fileName');

      setState(() {
        _image = localImage;
        imageFiles.add(localImage);
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('갤러리'),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _image == null ? Text('이미지를 선택해 주세요') : Image.file(_image!),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('갤러리에서 이미지 선택'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
              ),
              itemCount: imageFiles.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Container(
                    alignment: Alignment.center,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.file(
                        imageFiles[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Image.file(imageFiles[index]),
                          actions: <Widget>[
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}