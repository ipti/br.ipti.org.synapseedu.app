import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Student {
  int id;
  String name;
  String phone;

  Student({@required this.id, @required this.name, @required this.phone});

// 79999466220
  Future<Student> searchForStudent({String phoneNumber = '79999466220'}) async {
    final url = 'https://elesson.com.br/api/student/' + phoneNumber;

    final stringsStudent = await rootBundle.loadString('assets/json/students.json');
    final json = jsonDecode(stringsStudent);

    if (json[0]["valid"] == true) print("hey");
    Student student = Student(id: int.parse(json[0]['student']['id']), name: json[0]['student']['name'], phone: json[0]['student']['phone']);
    return student;
  }
}

class StudentQuery {
  bool valid;
  String error;
  Student student;

  StudentQuery({this.valid, this.error, this.student});

  Future<StudentQuery> searchStudent({String phoneNumber = '79999466220'}) async {
    final url = 'https://elesson.com.br/api/login';

    Response response = await Dio().post(
      url,
      options: Options(contentType: 'application/x-www-form-urlencoded'),
      data: {'phone': phoneNumber},
    );

    if (response.data[0]["valid"] == true) print("hey");
    Student student = Student(id: int.parse(response.data[0]['person'][0]['id']), name: response.data[0]['person'][0]['name'], phone: response.data[0]['person'][0]['phone']);
    StudentQuery studentQuery = StudentQuery(
      valid: response.data[0]["valid"],
      student: student,
    );

    return studentQuery;
  }
}
