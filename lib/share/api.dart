import 'package:dio/dio.dart';

/// <==tem exemplos aqui caso a gente precise==> https://github.com/flutterchina/dio/tree/master/example

var dio = Dio();
const BaseUrl = "http://app.elesson.com.br/api-synapse/synapse/";

class ApiClass {
  static Future getClasses(String schoolId) async {
    var url = BaseUrl + 'school/classroom/' + schoolId;
    return await dio.get(url);
  }
}

class ApiStudent {
  static Future getStudents(String classId) async {
    var url = BaseUrl + 'students/' + classId;
    return await dio.get(url);
  }
}

class ApiCobject {
  static Future getQuestao(String cobjectId) async {
    var url = 'https://elesson.com.br/api/offline/cobject/' + cobjectId;
    return await dio.get(url);
  }
}
