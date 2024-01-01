import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ViewContactPageWidget extends StatefulWidget {
  final String peopleName;

  ViewContactPageWidget({Key? key, this.peopleName = ''}) : super(key: key);


  @override
  State<ViewContactPageWidget> createState() => _ViewContactPageWidgetState();
}

class _ViewContactPageWidgetState extends State<ViewContactPageWidget> {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile() async {
    final path = await _localPath;
    return File('$path/contacts.json');
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
        ],
      ),
      actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              _deleteContact(contact);
              Navigator.of(context).pop();
            },
            child: Text('삭제'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('닫기'),
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
      appBar: AppBar(
        title: Text('연락처', style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 38, 39, 41), fontWeight: FontWeight.bold),),
      ),
      body: ListView.builder(
        itemCount: contacts.length * 2 - 1, // 선을 넣기 위해 항목 수 조정
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
            title: Text("전화번호 추가"),
            content: Column(
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
            actions: <Widget>[
              TextButton(
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
              ),
              TextButton(
                child: Text("취소"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      child: Icon(Icons.add),
    ),
    );
  }
}