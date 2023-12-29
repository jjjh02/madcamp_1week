import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';

class ViewContactPageWidget extends StatefulWidget {
  const ViewContactPageWidget({Key? key}) : super(key: key);

  @override
  State<ViewContactPageWidget> createState() => _ViewContactPageWidgetState();
}

class _ViewContactPageWidgetState extends State<ViewContactPageWidget> {
  final List<Contact> contacts = [
    Contact(name: 'Alpha', phoneNumber: '010-1111-1111', relation: 'family'),
    Contact(name: 'Bravo', phoneNumber: '010-2222-2222', relation: 'friend'),
    Contact(name: 'Charlie', phoneNumber: '010-3333-3333', relation: 'relative'),
    Contact(name: 'Delta', phoneNumber: '010-4444-4444', relation: 'family'),
    Contact(name: 'Echo', phoneNumber: '010-5555-5555', relation: 'friend'),
    Contact(name: 'Foxtrot', phoneNumber: '010-6666-6666', relation: 'friend'),
    Contact(name: 'Golf', phoneNumber: '010-7777-7777', relation: 'family'),
    Contact(name: 'Hotel', phoneNumber: '010-8888-8888', relation: 'friend'),
    Contact(name: 'India', phoneNumber: '010-9999-9999', relation: 'relative'),
  ];

void _showContactDetails(BuildContext context, Contact contact) {
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
        title: Text('연락처'),
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