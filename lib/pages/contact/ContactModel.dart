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
