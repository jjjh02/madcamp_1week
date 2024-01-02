import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:madcamp_1week/pages/calendar/ViewCalendarPage.dart';

class ViewContactPageWidget extends StatefulWidget {
  final String peopleName;

  ViewContactPageWidget({Key? key, this.peopleName = ''}) : super(key: key);


  @override
  State<ViewContactPageWidget> createState() => _ViewContactPageWidgetState();
}

class _ViewContactPageWidgetState extends State<ViewContactPageWidget> {

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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile() async {
    final path = await _localPath;
    return File('$path/contacts.json');
  }

  Future<File> get _eventLocalFile async {
  final path = await _localPath;
  return File('$path/events.json');
}

Future<void> _updateEventsForContactChange(String oldName, String newName) async {
  // 이벤트 파일 로드
  final eventFile = await _eventLocalFile; // 이벤트 파일 경로 가져오기
  String jsonEvents = await eventFile.readAsString();
  Map<String, dynamic> decodedJson = jsonDecode(jsonEvents);

  // 이벤트 업데이트
  decodedJson.forEach((key, value) {
    List<dynamic> updatedEvents = value.map((e) {
      if (e['who'] == oldName) {
        e['who'] = newName;
      }
      return e;
    }).toList();
    decodedJson[key] = updatedEvents;
  });

  // 변경된 이벤트 저장
  String updatedJsonEvents = jsonEncode(decodedJson);
  await eventFile.writeAsString(updatedJsonEvents);
}



  Future<void> _writeContacts() async {
    final file = await _localFile();
    final encodedData = jsonEncode(contacts);
    await file.writeAsString(encodedData);
  }

  Future<List<ContactPeople>> _loadContacts() async {
    try {
      final file = await _localFile();
      final contents = await file.readAsString();
      final decodedData = jsonDecode(contents) as List<dynamic>;
      return decodedData.map((json) => ContactPeople.fromJson(json)).toList();
    } catch (e) {
      // Handle errors or return an empty list
      return [];
    }
  }
  

 @override
  void initState() {
    super.initState();

    // Load contacts from file
    _loadContacts().then((loadedContacts) {
      setState(() {
        contacts = loadedContacts;
      });
    });

    if (widget.peopleName.isNotEmpty) {
      // peopleName에 해당하는 연락처 찾기 (null 허용)
      final ContactPeople? contact = contacts.firstWhere(
        (contact) => contact.name == widget.peopleName,
        orElse: () {
        // 기본 Contact 객체 반환 또는 다른 처리
        return ContactPeople(name: 'Unknown', phoneNumber: '', relation: '');
        }, // null 반환
      );
      if (contact != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _showContactDetails(context, contact));
      }
    }
  }
void _showEditDialog(BuildContext context, int index, ContactPeople contact) {
  TextEditingController nameController = TextEditingController(text: contact.name);
  TextEditingController phoneNumberController = TextEditingController(text: contact.phoneNumber);
  TextEditingController relationController = TextEditingController(text: contact.relation);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("연락처 수정"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "이름"),
            ),
            TextField(
              controller: phoneNumberController,
              decoration: InputDecoration(labelText: "전화번호"),
            ),
            TextField(
              controller: relationController,
              decoration: InputDecoration(labelText: "관계"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text("취소"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("저장"),
            onPressed: () {
              // 수정된 연락처 정보를 생성합니다.
              ContactPeople updatedContact = ContactPeople(
                name: nameController.text,
                phoneNumber: phoneNumberController.text,
                relation: relationController.text,
              );

              // 수정된 연락처 정보를 저장합니다.
              _saveUpdatedContact(index, updatedContact);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> _saveUpdatedContact(int index, ContactPeople updatedContact) async {
  if (index >= 0 && index < contacts.length) {
    String oldName = contacts[index].name;
    contacts[index] = updatedContact;

    // 연락처 리스트를 JSON 형식으로 인코딩합니다.
    String encodedData = jsonEncode(contacts.map((contact) => contact.toJson()).toList());

    // 파일에 저장합니다.
    final file = await _localFile();
    await file.writeAsString(encodedData);

    await _updateEventsForContactChange(oldName, updatedContact.name);
    setState(() {});
    
    // _events.forEach((key, events) {
    //   for (var event in events) {
    //     if (event.who == oldName) {
    //       event.who = updatedContact.name;
    //     }
    //   }
    // });

      setState(() {});
  }
}

void _showContactDetails(BuildContext context, ContactPeople contact) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            padding: EdgeInsets.only(top: 30.0),
            alignment: Alignment.center,
            child: Icon(Icons.person, size: 50.0, color: Color.fromARGB(255, 13, 114, 208)),
          ),
          /*IconButton(
            padding: EdgeInsets.only(top: 10.0, right: 10.0),
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close, size: 20.0),
          ),*/          
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
                    _deleteContact(contact);
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
                            onPressed: () {
                Navigator.of(context).pop();
                            },
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
              /*
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
              */
            ],
          ),
          
        ],      
      contentPadding: EdgeInsets.only(top: 30.0, left: 24.0, right: 24.0, bottom: 24.0),
    );
    },
  );
}

void _addOrUpdateContact(String name, String phoneNumber, String relation) {
  final newContact = ContactPeople(name: name, phoneNumber: phoneNumber, relation: relation);

  // Assuming contacts is a list that contains all the contacts
  contacts.add(newContact);

  // Add the contact to the UI immediately
  setState(() {});

  // Save contacts to file
  _writeContacts();

  // Clear the text fields after adding the contact
  nameController.clear();
  phoneNumberController.clear();
  relationController.clear();
}

void _deleteContact(ContactPeople contact) {
  contacts.remove(contact);
  
  setState(() {});
  
  // Save contacts to file after deletion
  _writeContacts();
}


  //String? _selectedRelation;
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final relationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('인연 저장소'),
      ),
      body: 
      ListView.builder(
        itemCount: contacts.length == 0 ? contacts.length : contacts.length * 2 - 1, // 선을 넣기 위해 항목 수 조정
        itemBuilder: (context, index) {
          if (index.isOdd) {
            // 홀수 인덱스에 Divider 추가
            return Divider();
          } else {
            // 짝수 인덱스에 ListTile 추가
            final contactIndex = index ~/ 2;
            return ListTile(
              title: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: contacts[contactIndex].name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 20.0, // 이름의 폰트 사이즈
                      ),
                    ),
                    TextSpan(
                      text: ' ${contacts[contactIndex].phoneNumber}',
                      style: TextStyle(
                        fontSize: 18.0, // 전화번호의 폰트 사이즈
                        color: Colors.grey, // 선택사항: 전화번호에 대한 색상
                      ),
                    ),
                  ],
                ),
              ),

              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                width: 80,
                child: ElevatedButton(
                            onPressed: () {
                              
                _showEditDialog(context, contactIndex, contacts[contactIndex]);
                            },
                            child: Text('수정'),
                            style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xffFDF0E2), // 취소 버튼의 배경색을 하얗게 설정
                                  foregroundColor: Colors.black, // 텍스트 색상을 검정으로 설정
                                  shape: RoundedRectangleBorder( // 둥근 사각형 모양
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(color: const Color.fromARGB(255, 203, 203, 203)), // 회색 테두리
                                  ),
                                ),
                          ),
              ),
              /*
              SizedBox(
                width: 50,
                child: ElevatedButton(
                            onPressed: () {
                _showContactDetails(context, contacts[contactIndex]);
                            },
                            child: Text('보기'),
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
              */
                ],
              ),
              onTap: () => _showContactDetails(context, contacts[contactIndex]),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        //final whoController = TextEditingController();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            //title: Text("전화번호 추가"),
            content: Container(
              height:210,
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "이름"),
                  ),
                  TextField(
                    controller: phoneNumberController,
                    decoration: InputDecoration(labelText: "전화번호"),
                  ),
                  TextField(
                    controller: relationController,
                    decoration: InputDecoration(labelText: "관계"),
                  ),
                  
                  ]),
            ),
            actions: <Widget>[

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextButton(
                      child: Text("추가"),
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            phoneNumberController.text.isNotEmpty &&
                            relationController.text.isNotEmpty) {
                          _addOrUpdateContact(
                            nameController.text,
                            phoneNumberController.text,
                            relationController.text,
                          );
                          Navigator.of(context).pop();
                        }
                      },
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
                  child: Text("취소"),
                  onPressed: () => Navigator.of(context).pop(),
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
          ),
        );
      },
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