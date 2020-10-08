import 'dart:collection';

import './model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/all.dart';

// template code, disciplina, texto da questão, alternativas e qual é a certa
// tem áudio? tem imagem? <- perguntas e respostas

class Cobjects extends StateNotifier<List<Cobject>> {
  Cobjects() : super([]);

  final List<Question> _questionList = [];
  List<Question> _items = [];

  List<Question> get items => UnmodifiableListView(_questionList);

  readFile() async {
    var dio = Dio();
    Response response = await dio.get(
        'http://app.elesson.com.br/api-synapse/synapse/offline/cobject/1471');
    print(response.data);
  }

  String mockJson;

  // Future<void> fetchCobjects() async {

  void fetchCobjects(List<dynamic> cobjectData) {
    _items.clear();

    // mockJson = stringJson(3);

    // var url =
    //     'http://app.elesson.com.br/api-synapse/synapse/offline/cobject/1471';
    // var dio = Dio();

    try {
      // Response response = await dio.get(url);

      // final response = await http.get(url);
      // var cobjectDataz =
      //     json.decode((response.data).toString()) as List<dynamic>;

      // String jasonEncoded = jsonEncode(CObject);
      // // print(jasonEncoded);
      // var cobjectData = json.decode(jasonEncoded) as List<dynamic>;

      //var cobjectData = json.decode(mockJson) as List<dynamic>;

      if (cobjectData == null) {
        return null;
      }
      final List<Question> loadedQuestion = [];

      cobjectData.forEach((json) {
        loadedQuestion.add(Question.fromJson(json));
      });
      _questionList.addAll(loadedQuestion);
      // notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
