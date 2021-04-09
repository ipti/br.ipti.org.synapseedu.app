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

  Student(
      {@required this.id,
      @required this.name,
      @required this.phone,
      @required this.actorId,
      @required this.personage_id});

// 79999466220
  //   Future<Student> searchForStudent({String phoneNumber = '79999466220'}) async {
  Future<Student> searchForStudent({String phoneNumber}) async {
    // final url = 'https://elesson.com.br/api/student/' + phoneNumber;

    final stringsStudent =
        await rootBundle.loadString('assets/json/students.json');
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

class ActorAccess {
  String id;
  String uuid;
  String date;
  String cobjectBlockId;

  ActorAccess(
      {@required this.id,
      @required this.uuid,
      @required this.date,
      @required this.cobjectBlockId});
}

class LoginQuery {
  bool valid;
  String error;
  Student student;
  ActorAccess actorAccess;

  LoginQuery({this.valid, this.error, this.student, this.actorAccess});

  // Future<LoginQuery> searchStudent({String phoneNumber = '79999466220'}) async {
  Future<LoginQuery> searchStudent(bool isQrcode,
      {String phoneNumber, String studentUuid}) async {
    String url;
    Student student;
    Response response;
    ActorAccess actorAccess;

    if (isQrcode) {
      url = 'https://elesson.com.br/api/loginuuid';
      response = await Dio().post(
        url,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
        data: {'uuid': studentUuid},
      );
    } else {
      url = 'https://elesson.com.br/api/login';
      response = await Dio().post(
        url,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
        data: {'phone': phoneNumber},
      );
    }

    if (response.data[0]["valid"] == true) {
      // print(response.data[0]['person'][0]['id']);

      student = Student(
        id: int.parse(response.data[0]['person'][0]['id']) ?? -1,
        name: response.data[0]['person'][0]['name'] ?? 'Aluno(a)',
        phone: response.data[0]['person'][0]['phone'] ?? "",
        actorId: response.data[0]['actor'][0]['id'] ?? "",
        personage_id: int.parse(response.data[0]['personage'][0]['id']) ?? -1,
      );
    }

    if (studentUuid != null)
      actorAccess = ActorAccess(
          id: response.data[0]["actorAccess"][0]["id"],
          uuid: response.data[0]["actorAccess"][0]["uuid"],
          date: response.data[0]["actorAccess"][0]["date"],
          cobjectBlockId: response.data[0]["actorAccess"][0]
              ["cobject_block_fk"]);
    // if (response.data[0]["valid"] != trye) print(student.name);
    LoginQuery loginQuery = LoginQuery(
        valid: response.data[0]["valid"],
        student: student,
        error: response.data[0]["valid"] == false
            ? response.data[0]["error"][0]
            : '',
        actorAccess: actorAccess);
    return loginQuery;
  }
}
