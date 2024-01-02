import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class MyImagePicker extends StatefulWidget {
  @override
  _MyImagePickerState createState() => _MyImagePickerState();
}

class _MyImagePickerState extends State<MyImagePicker> {
  List<Map<String, dynamic>> _imagesWithInfo = [];

  // 파일 경로 생성 함수
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/images_info.json');
  }

  // 이미지 정보를 파일에 저장
  Future<void> _saveImagesInfo() async {
    final file = await _getFile();
    String jsonContent = jsonEncode(_imagesWithInfo);
    await file.writeAsString(jsonContent);
  }

  // 파일에서 이미지 정보를 로드
  Future<void> _loadImagesInfo() async {
    try {
      final file = await _getFile();
      String jsonContent = await file.readAsString();
      List<dynamic> decodedList = jsonDecode(jsonContent);

      setState(() {
        _imagesWithInfo = List<Map<String, dynamic>>.from(decodedList);
      });
    } catch (e) {
      // 파일이 존재하지 않거나 읽을 수 없는 경우 무시
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImagesInfo();
  }

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
        _saveImagesInfo(); // 이미지 정보를 저장
      }
    }
  }

  Future<Map<String, dynamic>?> _showConfirmationDialog(File imageFile) async {
    TextEditingController dateController = TextEditingController();

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: Text('사진 추가'),
          shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0), // 여기서 모서리의 둥근 정도를 조절하세요
  ),
          backgroundColor: Colors.white,
          
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               AspectRatio(aspectRatio: 1/1, child: Image.file(
                  imageFile,
                  height: 500, // 이미지 높이 조절
                    width: double.maxFinite,
                    fit: BoxFit.contain,
                ),), 
                SizedBox(height: 16),
                TextField(
                  controller: dateController,
                  decoration: InputDecoration(
    labelText: '날짜 입력: YYYY-MM-DD',
    labelStyle: TextStyle(
      color: Colors.grey, // 여기에서 원하는 색상을 설정하세요.
    ),
    contentPadding: EdgeInsets.only(top: 8.0, bottom: 0.0),
  ),
  
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop({
                        'image': imageFile.path, // 파일 경로 저장
                        'date': dateController.text,
                      });
                    },
                    child: Text('추가'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    backgroundColor: Color.fromARGB(255, 13, 114, 208), // 추가 버튼의 배경색을 파랑으로 설정
                    //textStyle: TextStyle(color: Colors.white),// 텍스트 색상을 흰색으로 설정
                    shape: RoundedRectangleBorder( // 둥근 사각형 모양
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  ),
                ),
                SizedBox(width: 20,),
                SizedBox(
                  width: 120,
                  child: TextButton(
                                onPressed: () => Navigator.of(context).pop(null),
                                child: Text('취소'),
                                style: TextButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 255, 255), // 취소 버튼의 배경색을 하얗게 설정
                                foregroundColor: Colors.black, // 텍스트 색상을 검정으로 설정
                                shape: RoundedRectangleBorder( // 둥근 사각형 모양
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: const Color.fromARGB(255, 203, 203, 203)), // 회색 테두리
                                ),
                              ),
                              ),
                ),

              ],
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
                    File(imageInfo['image']), // 파일 경로에서 이미지 로드
                    height: 400, // 이미지 높이 조절
                    width: double.maxFinite,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text('날짜: ${imageInfo['date']}', style: TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () {
                  _deleteImage(imageInfo['image']);
                  Navigator.of(context).pop();
                },
                child: Text('삭제'),
                style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 13, 114, 208), // 추가 버튼의 배경색을 파랑으로 설정
                      //textStyle: TextStyle(color: Colors.white),// 텍스트 색상을 흰색으로 설정
                      shape: RoundedRectangleBorder( // 둥근 사각형 모양
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
              ),
            ),
            SizedBox(width: 20,),
            SizedBox(
              width: 120,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('닫기'),
                style: TextButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 255, 255, 255), // 취소 버튼의 배경색을 하얗게 설정
                                  foregroundColor: Colors.black, // 텍스트 색상을 검정으로 설정
                                  shape: RoundedRectangleBorder( // 둥근 사각형 모양
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: const Color.fromARGB(255, 203, 203, 203)), // 회색 테두리
                                  ),
                                ),
              ),
            )
            ]),
            
          ],
        );
      },
    );
  }

  void _deleteImage(String imagePath) {
    setState(() {
      _imagesWithInfo.removeWhere((element) => element['image'] == imagePath);
    });
    _saveImagesInfo(); // 이미지 정보를 저장
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("만남 저장소", style: TextStyle(fontSize: 30),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 6.0,
          ),
          itemCount: _imagesWithInfo.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => _showImageDialog(_imagesWithInfo[index]),
              child: Image.file(File(_imagesWithInfo[index]['image']), fit: BoxFit.cover),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        tooltip: 'Pick Image',
        child: Icon(
              Icons.add,
              color: Color.fromRGBO(117, 117, 117, 1),
              size: 32,
            ),
            backgroundColor:  Color.fromRGBO(255, 255, 255, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
      ),
    );
  }
}
