import 'package:dio/dio.dart';

/// <==tem exemplos aqui caso a gente precise==> https://github.com/flutterchina/dio/tree/master/example

var dio = Dio();
const BaseUrl = "http://app.elesson.com.br/api-synapse/synapse/";

class API_TURMA {
  static Future getTurmas(String id_escola) async {
    var url = BaseUrl + 'school/classroom/' + id_escola;
    return await dio.get(url);
  }
}

class API_ALUNO {
  static Future getAlunos(String id_turma) async {
    var url = BaseUrl + 'students/' + id_turma;
    return await dio.get(url);
  }
}
  class API_COBJECT {
  static Future getQuestao(String id_cobject) async {
  var url = 'https://elesson.com.br/api/offline/cobject/' + id_cobject;
  return await dio.get(url);
  }
}

