import 'package:flutter/material.dart';
import 'package:madcamp_1week/pages/contact/ContactModel.dart';


class ViewContactPageWidget extends StatefulWidget {
  const ViewContactPageWidget({Key? key}) : super(key: key);


  @override
  State<ViewContactPageWidget> createState() => _ViewContactPageWidgetState();
}


class _ViewContactPageWidgetState extends State<ViewContactPageWidget> {
  final List<Contact> contacts = [
    Contact(name: 'Juho Song', phoneNumber: '010-4055-5244'),
    Contact(name: 'A', phoneNumber: '010-1111-1111'),
    Contact(name: 'B', phoneNumber: '010-2222-2222'),
    Contact(name: 'C', phoneNumber: '010-3333-3333'),
    Contact(name: 'D', phoneNumber: '010-4444-4444'),
    Contact(name: 'E', phoneNumber: '010-5555-5555'),
    Contact(name: 'F', phoneNumber: '010-6666-6666'),
    Contact(name: 'G', phoneNumber: '010-7777-7777'),
    Contact(name: 'H', phoneNumber: '010-8888-8888'),
    Contact(name: 'I', phoneNumber: '010-9999-9999'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('연락처'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index].name),
            subtitle: Text(contacts[index].phoneNumber),
          );
        }
      )


    );
  }
}
