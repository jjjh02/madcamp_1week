import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';
import 'package:madcamp_1week/pages/gallery/ViewGalleryPage.dart';

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class ViewEventInfoPage extends StatelessWidget {
  final DateTime? date;
  final String title;
  final String time;
  final String people;

  ViewEventInfoPage({Key? key, required this.date, required this.title, required this.time, required this.people}) : super(key: key);

Future<File?> getImageForDate(DateTime? date) async {
  if (date == null) return null;

  String dateString = DateFormat('yyyy-MM-dd').format(date);
  List<Map<String, dynamic>> imagesWithInfo = await loadImagesInfo(); // 이미지 정보 로드 함수

  var foundImage = imagesWithInfo.firstWhere(
    (imageInfo) => imageInfo['date'] == dateString,
    orElse: () => {
      'image': 'default_image_path', // 기본 이미지 경로
      'date': dateString,
      'text': 'No image found for this date' // 기본 텍스트
    },
  );

  return foundImage != null ? File(foundImage['image']) : null;
}

Future<File> _getImageInfoFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File('${directory.path}/images_info.json');
}
// 이미지 정보 로드 함수
Future<List<Map<String, dynamic>>> loadImagesInfo() async {
  // 이미지 정보를 로드하는 로직 구현
  // ViewGalleryPage.dart의 _loadImagesInfo 함수와 유사하게 구현
  try {
    final file = await _getImageInfoFile();
    if (!file.existsSync()) {
      return [];
    }

    String jsonContent = await file.readAsString();
    List<dynamic> decodedList = jsonDecode(jsonContent);
    return List<Map<String, dynamic>>.from(decodedList);
  } catch (e) {
    // 오류 처리 (파일이 존재하지 않거나 읽을 수 없는 경우)
    return [];
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
    icon: Icon(Icons.arrow_back),
    onPressed: () {
      Navigator.of(context).pop();
    },
  ),
        backgroundColor: Colors.white,
        title: Text('이벤트 세부사항'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
              child: Text('$title', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Text('시간', style: TextStyle(fontSize: 15, color: Color(0xff616161)),),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Text('$time', style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 0, 0),
              child: Text('참석자', style: TextStyle(fontSize: 15, color: Color(0xff616161))),
            ),
            InkWell(
              onTap: () {
                showContactDetails(context, people);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text('$people', style: TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 10),
              child: Text('사진', style: TextStyle(fontSize: 15, color: Color(0xff616161)),),
            ),
            //////이미지 넣을 자리///////
            // 해당 날짜의 이미지를 갤러리 추가정보로부터 찾아서 넣어야 함
            FutureBuilder<File?>(
      future: getImageForDate(date),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.data != null && snapshot.data!.existsSync()) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(height: 350,child: Image.file(snapshot.data!)),
        ); // 이미지 파일이 존재하면 표시
      } else {
        return TextButton(onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyImagePicker()), // MyPicker 위젯으로 이동
    );
  }, 
  child: Padding(
    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
    child: Row(
      mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞게 조정
      children: <Widget>[
        Icon(Icons.add_a_photo_outlined, color: Color.fromARGB(255, 13, 114, 208)), // 사진 추가 아이콘
        SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
        Text('사진 추가', style: TextStyle(color: Colors.black),), // 버튼의 텍스트
      ],
    ),
  ),); // 이미지가 없을 때 텍스트 표시
      }
    } else if (snapshot.hasError) {
      return Text('이미지 로드 중 오류 발생: ${snapshot.error}'); // 오류 발생시 텍스트 표시
    } else {
      return CircularProgressIndicator(); // 로딩 중 표시
    }
      },
    ),
    
          ],
        ),
      
    );
  }

  void showContactDetails(BuildContext context, String name) {
    ContactPeople? contact = getContactByName(name);
    if (contact != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('연락처 상세 정보'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('이름: ${contact.name}'),
                Text('전화번호: ${contact.phoneNumber}'),
                Text('관계: ${contact.relation}'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('닫기'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}

ContactPeople? getContactByName(String name) {
  return contacts.firstWhere(
    (contact) => contact.name.toLowerCase() == name.toLowerCase(),
    //orElse: () => null,
   
  );
}