import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';


class ViewContactPageWidget extends StatefulWidget {
  final String peopleName;

  ViewContactPageWidget({Key? key, this.peopleName = ''}) : super(key: key);


  @override
  State<ViewContactPageWidget> createState() => _ViewContactPageWidgetState();
}

class _ViewContactPageWidgetState extends State<ViewContactPageWidget> {

 @override
  void initState() {
    super.initState();
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
      IconButton(
        padding: EdgeInsets.only(top: 10.0, right: 10.0),
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.close, size: 20.0),
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
    ],
  ),
  contentPadding: EdgeInsets.only(top: 30.0, left: 24.0, right: 24.0, bottom: 24.0),
);
    },
  );
}

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
    );
  }
}