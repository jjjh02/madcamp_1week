import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';
import 'package:madcamp_1week/pages/gallery/ViewGalleryPage.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw '전화를 걸 수 없습니다.';
    }
  }

  void _sendSMS(String phoneNumber) async {
    final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    } else {
      throw '문자를 보낼 수 없습니다.';
    }
  }

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
        title: Text('만남 정보', style: TextStyle(fontSize: 30),),
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
              child: Text('인연', style: TextStyle(fontSize: 15, color: Color(0xff616161))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                    child: Text('$people', style: TextStyle(fontSize: 20, )),
                  ),
                  IconButton(
  icon: Icon(Icons.chevron_right), // 여기에 원하는 아이콘을 선택하세요.
  onPressed: () {
    showContactDetails(context, people);
  },
),
              ],
            ),
            
            /*
            InkWell(
              onTap: () {
                showContactDetails(context, people);
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Text('$people', style: TextStyle(fontSize: 20, decoration: TextDecoration.underline)),
              ),
            ),
            */
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 0, 10),
              child: Text('장면', style: TextStyle(fontSize: 15, color: Color(0xff616161)),),
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
        Icon(Icons.add_a_photo_outlined, color: Color(0xff62838C)), // 사진 추가 아이콘
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      titlePadding: EdgeInsets.all(0),
      title: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: EdgeInsets.only(top: 30.0),
            alignment: Alignment.center,
            child: Icon(Icons.person, size: 50.0, color: Color(0xff62838C)),
          ),
                 
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 20.0),
          Text(
            '${contact.name}',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            '${contact.phoneNumber}',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            '${contact.relation}',
            style: TextStyle(fontSize: 18.0),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                        icon: Icon(Icons.local_phone_rounded, color: Color.fromARGB(255, 115, 115, 116)),
                        onPressed: () => _makePhoneCall(contact.phoneNumber),
                      ),
                      IconButton(
                    icon: Icon(Icons.message_rounded, color: Color.fromARGB(255, 113, 114, 115)),
                    onPressed: () => _sendSMS(contact.phoneNumber),
                  ),
            ],
          ),
                
        ],
      ),
      actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: 120,
                child: ElevatedButton(
                            onPressed: () {
                Navigator.of(context).pop();
                            },
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
              ),
             
            ],
          ),
          
        ],      
      contentPadding: EdgeInsets.only(top: 30.0, left: 24.0, right: 24.0, bottom: 24.0),
    );
        },
      );
    }
  }
}

ContactPeople? getContactByName(String name) {
  return contacts.firstWhere(
    (contact) => contact.name.toLowerCase() == name.toLowerCase(),
    orElse: () => ContactPeople(name: '', phoneNumber: '', relation: ''),
   
  );
}