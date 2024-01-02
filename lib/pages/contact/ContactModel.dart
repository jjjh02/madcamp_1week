import 'dart:convert';
import 'package:flutter/material.dart';

// json데이터 형식
List<Map<String, dynamic>> jsonData = [
  {"name": "Alpha", "phoneNumber": "010-1111-1111", "relation": "family"},
  {"name": "Bravo", "phoneNumber": "010-2222-2222", "relation": "friend"},
  {"name": "Charlie", "phoneNumber": "010-3333-3333", "relation": "relative"},
  {"name": "Delta", "phoneNumber": "010-4444-4444", "relation": "family"},
  {"name": "Echo", "phoneNumber": "010-5555-5555", "relation": "friend"},
  {"name": "Foxtrot", "phoneNumber": "010-6666-6666", "relation": "friend"},
  {"name": "Golf", "phoneNumber": "010-7777-7777", "relation": "family"},
  {"name": "Hotel", "phoneNumber": "010-8888-8888", "relation": "friend"},
  {"name": "India", "phoneNumber": "010-9999-9999", "relation": "relative"}
];

// Contact.fromJson이 jsonData를 
class ContactPeople {
   String name;
   String phoneNumber;
   String relation;


  ContactPeople({required this.name, required this.phoneNumber, required this.relation});

  // Convert a ContactPeople object to a Map object
  Map<String, dynamic> toJson() => {
    'name' : name,
    'phoneNumber' : phoneNumber,
    'relation' : relation,
  };

  factory ContactPeople.fromJson(Map<String, dynamic> json) {
    return ContactPeople(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      relation: json['relation'],
    );
  }
}

// contacts: jsonData에서 jsonItem을 구별해서 jsonItem을 Contact.fromJson함수를 통해서 Contact객체로 만들고 List형식으로 return함
List<ContactPeople> contacts = jsonData.map((jsonItem) {
  return ContactPeople.fromJson(jsonItem);
}).toList();