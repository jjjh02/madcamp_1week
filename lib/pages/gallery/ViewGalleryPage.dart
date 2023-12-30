import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker extends StatefulWidget {
  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  List<Map<String, dynamic>> _imagesWithInfo = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      // 사용자에게 선택 여부 및 정보 입력을 묻는 다이얼로그를 표시
      Map<String, dynamic>? imageInfo = await _showConfirmationDialog(imageFile);

      if (imageInfo != null) {
        setState(() {
          _imagesWithInfo.add(imageInfo);
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _showConfirmationDialog(File imageFile) async {
    TextEditingController textController = TextEditingController();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('사진 추가'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  imageFile,
                  height: 150, // 이미지 높이 조절
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(labelText: '추가 정보 입력'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'image': imageFile,
                  'text': textController.text,
                });
              },
              child: Text('추가'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('취소'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showImageDialog(Map<String, dynamic> imageInfo) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.maxFinite,
                  child: Image.file(
                    imageInfo['image'],
                    height: 250, // 이미지 높이 조절
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text('추가 정보: ${imageInfo['text']}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _deleteImage(imageInfo['image']);
                Navigator.of(context).pop();
              },
              child: Text('삭제'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }

  void _deleteImage(File imageFile) {
    setState(() {
      _imagesWithInfo.removeWhere((element) => element['image'] == imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker with Grid"),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _imagesWithInfo.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => _showImageDialog(_imagesWithInfo[index]),
            child: Image.file(_imagesWithInfo[index]['image'], fit: BoxFit.cover),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.photo_library),
      ),
    );
  }
}
