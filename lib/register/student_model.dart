import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elesson/activity_selection/block_selection_view.dart';
import 'package:elesson/share/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Student {
  int id;
  String? name;
  String? phone;
  String? actorId;
  int personageId;
  String? classroomFk;

  Student(
      {required this.id,
      required this.name,
      required this.phone,
      required this.actorId,
      required this.personageId,
      this.classroomFk});

// 79999466220
  //   Future<Student> searchForStudent({String phoneNumber = '79999466220'}) async {
  Future<Student> searchForStudent({String? phoneNumber}) async {
    // final url = '${BaseUrl}/student/' + phoneNumber;

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
      personageId: int.parse(json[0]['personage'][0]['id']),
    );
    return student;
  }
}

class ActorAccess {
  String? id;
  String? uuid;
  String? date;
  Map<String, String?>? actorAcessBlocks;

  ActorAccess(
      {required this.id,
      required this.uuid,
      required this.date,
      this.actorAcessBlocks});
}

class LoginQuery {
  bool? valid;
  String? error;
  Student? student;
  ActorAccess? actorAccess;

  LoginQuery({this.valid, this.error, this.student, this.actorAccess});

  // Future<LoginQuery> searchStudent({String phoneNumber = '79999466220'}) async {
  Future<LoginQuery> searchStudent(bool isQrcode,
      {String? phoneNumber, String? studentUuid}) async {
    String url;
    String classroomFk;
    Student? student;
    Response response;
    ActorAccess? actorAccess;
    Map<String, String?> blocks = {};
    String? degreeFkBlock;

    if (isQrcode) {
      url = '${BaseUrl}/loginuuid';
      response = await Dio().post(
        url,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
        data: {'uuid': studentUuid},
      );
    } else {
      url = '${BaseUrl}/login';
      response = await Dio().post(
        url,
        options: Options(contentType: 'application/x-www-form-urlencoded'),
        data: {'phone': phoneNumber},
      );
    }
    print(response.data);
    // final stringsStudent =
    //     await rootBundle.loadString('assets/json/reduzido.json');
    // final response.data = jsonDecode(stringsStudent);

    if (response.data[0]["valid"] == true) {
      // print(response.data[0]['person'][0]['id']);

      student = Student(
        id: int.parse(response.data[0]['person'][0]['id'] ?? "-1"),
        name: response.data[0]['person'][0]['name'] ?? 'Aluno(a)',
        phone: response.data[0]['person'][0]['phone'] ?? "",
        actorId: response.data[0]['actor'][0]['id'] ?? "-1",
        personageId: int.parse(response.data[0]['personage'][0]['id'] ?? "-1"),
        classroomFk: response.data[0]['actor'][0]["classroomFk"],
      );
    }

    if (student!.classroomFk == null) print("DEU BOA");

    if (studentUuid != null) {
      response.data[0]["actorAccessBlocks"].forEach((block) {
        degreeFkBlock = block["degreeFk"];
        blocks.putIfAbsent("${degreeFkBlock}_${block["discipline_fk"]}",
            () => block["cobjectBlockFk"]);
        // print(block);
      });
      actorAccess = ActorAccess(
        id: response.data[0]["actorAccess"][0]["id"],
        uuid: response.data[0]["actorAccess"][0]["uuid"],
        date: response.data[0]["actorAccess"][0]["date"],
        actorAcessBlocks: blocks,
      );
      print('BLOCKS: $blocks');
    }
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

  void getLoginTrial(BuildContext context) async {
    String url = "BaseUrl/logintrial";
    Response response = await Dio().post(url);

    String trialUuid = response.data[0]["uuid"];

    studentUuidProcessing(trialUuid, context);
  }

  void studentUuidProcessing(String studentUuid, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginQuery loginQuery =
        await LoginQuery().searchStudent(true, studentUuid: studentUuid);

    if (loginQuery.valid != false) print('UID:' + studentUuid);

    var discipline = ApiBlock.getDiscipline(loginQuery.actorAccess!.id);

    prefs.setBool('isConfirmed', true);
    prefs.setString('student_uuid', studentUuid);
    prefs.setString(
        'student_name', loginQuery.student!.name!.split(" ")[0].toUpperCase());
    if (loginQuery.student!.id != -1)
      prefs.setInt('student_id', loginQuery.student!.id);
    if (loginQuery.student!.phone!.isNotEmpty)
      prefs.setString('student_phone', loginQuery.student!.phone!);
    if (loginQuery.student!.actorId!.isNotEmpty)
      prefs.setString('actor_id', loginQuery.student!.actorId!);
    if (loginQuery.actorAccess!.actorAcessBlocks != null) {
      loginQuery.actorAccess!.actorAcessBlocks!.forEach((key, value) {
        print('KEY: $key and $value');
        prefs.setString('block_$key', value!);
      });
    }
    if (loginQuery.student!.classroomFk != null)
      prefs.setString("classroomFk", loginQuery.student!.classroomFk!);

    Navigator.pushReplacementNamed(context, BlockSelection.routeName);
  }
}
