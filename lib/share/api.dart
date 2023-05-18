import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// <==tem exemplos aqui caso a gente precise==> https://github.com/flutterchina/dio/tree/master/example

var dio = Dio()..interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: true, error: true, compact: true, maxWidth: 90));

const BaseUrl = "https://apielesson.azurewebsites.net/api-synapse/synapse";

class ApiClass {
  static Future getClasses(String schoolId) async {
    var url = BaseUrl + '/school/classroom/' + schoolId;
    try {
      return await dio.get(url);
    } catch (e) {
      print(e);
    }
  }
}

class ApiStudent {
  static Future getStudents(String classId) async {
    var url = BaseUrl + '/students/' + classId;
    try {
      return await dio.get(url);
    } catch (e) {
      print(e);
    }
  }
}

class ApiCobject {
  static Future getQuestao(String cobjectId) async {
    var url = '$BaseUrl/offline/cobject/' + cobjectId;
    try {
      return await dio.get(url);
    } catch (e) {
      print(e);
    }
  }
}

class ApiBlock {
  static Future<String?> getBlockByDiscipline(String disciplineId) async {
    var url = '$BaseUrl/discipline/cobjectblock/' + disciplineId;
    String? blockId;
    var response;
    try {
      response = await dio.get(url);
      blockId = response.data[0]["cobjectblock"][0]["id"];
    } catch (e) {
      blockId = "-1";
    }

    return blockId;
  }

  static String getDiscipline(String? disciplineId) {
    switch (disciplineId) {
      case "1":
        return "Português";
        break;
      case "2":
        return "Matemática";
        break;
      case "3":
        return "Ciências";
        break;
      default:
        return "Elesson";
    }
  }

  static Future getBlock(String blockId) async {
    // var url =
    //     'http://app.apielesson.azurewebsites.net/api-synapse/synapse/cobjectblock/cobjects/' +
    //         blockId;
    var url = '$BaseUrl/cobjectblock/cobjects/' + blockId;
    try {
      return await dio.get(url);
    } catch (e) {
      return "-1";
    }
  }
}
