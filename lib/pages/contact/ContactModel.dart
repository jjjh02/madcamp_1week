import 'dart:convert';
import 'package:flutter/material.dart';


class Contact {
  final String name;
  final String phoneNumber;
  final String relation;


  Contact({required this.name, required this.phoneNumber, required this.relation});


  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      relation: json['relation'],
    );
  }
}

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