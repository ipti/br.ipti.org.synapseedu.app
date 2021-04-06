import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Student {
  int id;
  String name;
  String phone;
  String actorId;
  int personage_id;

  Student({@required this.id, @required this.name, @required this.phone, @required this.actorId, @required this.personage_id});

// 79999466220
  //   Future<Student> searchForStudent({String phoneNumber = '79999466220'}) async {
  Future<Student> searchForStudent({String phoneNumber}) async {
    // final url = 'https://elesson.com.br/api/student/' + phoneNumber;

    final stringsStudent = await rootBundle.loadString('assets/json/students.json');
    final json = jsonDecode(stringsStudent);

    print(json[0]['person'][0]['id']);

    if (json[0]["valid"] == true) print("hey");
    Student student = Student(
      id: int.parse(json[0]['person'][0]['id']),
      name: json[0]['person'][0]['name'],
      phone: json[0]['person'][0]['phone'],
      actorId: json[0]['actor'][0]['id'],
      personage_id: int.parse(json[0]['personage'][0]['id']),
    );
    return student;
  }
}

class StudentQuery {
  bool valid;
  String error;
  Student student;

  StudentQuery({this.valid, this.error, this.student});

  // Future<StudentQuery> searchStudent({String phoneNumber = '79999466220'}) async {
  Future<StudentQuery> searchStudent(String phoneNumber) async {
    final url = 'https://elesson.com.br/api/login';
    Student student;

    Response response = await Dio().post(
      url,
      options: Options(contentType: 'application/x-www-form-urlencoded'),
      data: {'phone': phoneNumber},
    );

    // if (response.data[0]["valid"] == true) print("hey");
    print(response.data[0]);
    if (response.data[0]["valid"] == true) {
      print(response.data[0]['person'][0]['id']);

      student = Student(
        id: int.parse(response.data[0]['person'][0]['id']),
        name: response.data[0]['person'][0]['name'],
        phone: response.data[0]['person'][0]['phone'],
        actorId: response.data[0]['actor'][0]['id'],
        personage_id: int.parse(response.data[0]['personage'][0]['id']),
      );
    }
    // if (response.data[0]["valid"] != trye) print(student.name);
    StudentQuery studentQuery = StudentQuery(
      valid: response.data[0]["valid"],
      student: student,
      error: response.data[0]["valid"] == false ? response.data[0]["error"][0] : '',
    );

    return studentQuery;
  }
}
