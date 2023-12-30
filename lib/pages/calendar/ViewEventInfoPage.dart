import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';

class ViewEventInfoPage extends StatelessWidget {
  final String title;
  final String time;
  final String people;

  ViewEventInfoPage({Key? key, required this.title, required this.time, required this.people}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('이벤트 정보'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('일정 이름: $title'),
            Text('약속 시간: $time'),
            InkWell(
              onTap: () {
                showContactDetails(context, people);
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('만날 사람: $people', style: TextStyle(decoration: TextDecoration.underline)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showContactDetails(BuildContext context, String name) {
    Contact? contact = getContactByName(name);
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

Contact? getContactByName(String name) {
  return contacts.firstWhere(
    (contact) => contact.name.toLowerCase() == name.toLowerCase(),
    //orElse: () => null,
  );
}