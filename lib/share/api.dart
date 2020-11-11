import 'package:dio/dio.dart';

/// <==tem exemplos aqui caso a gente precise==> https://github.com/flutterchina/dio/tree/master/example

var dio = Dio();
const BaseUrl = "http://app.elesson.com.br/api-synapse/synapse/";

class ApiClass {
  static Future getClasses(String schoolId) async {
    var url = BaseUrl + 'school/classroom/' + schoolId;
    try {
      return await dio.get(url);
    } catch (e) {
      print(e.message);
    }
  }
}

class ApiStudent {
  static Future getStudents(String classId) async {
    var url = BaseUrl + 'students/' + classId;
    try {
      return await dio.get(url);
    } catch (e) {
      print(e.message);
    }
  }
}

class ApiCobject {
  static Future getQuestao(String cobjectId) async {
    var url = 'https://elesson.com.br/api/offline/cobject/' + cobjectId;
    try {
      return await dio.get(url);
    } catch (e) {
      print(e.message);
    }
  }
}

class ApiBlock {
  static Future getBlock(String blockId) async {
    var url =
        'http://app.elesson.com.br/api-synapse/synapse/cobjectblock/cobjects/' +
            blockId;
    try {
      return await dio.get(url);
    } catch (e) {
      print(e.message);
    }
  }
}
