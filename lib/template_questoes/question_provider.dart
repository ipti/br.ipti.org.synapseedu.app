import 'dart:collection';

import './model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/all.dart';

// template code, disciplina, texto da questão, alternativas e qual é a certa
// tem áudio? tem imagem? <- perguntas e respostas

class Cobjects extends StateNotifier<List<Cobject>> {
  Cobjects() : super([]);

  final List<Cobject> _cobjectList = [];
  List<Cobject> _items = [];

  List<Cobject> get items => _cobjectList;

  readFile() async {
    var dio = Dio();
    Response response = await dio.get(
        'http://app.elesson.com.br/api-synapse/synapse/offline/cobject/1471');
    print(response.data);
  }

  void fetchCobjects(List<dynamic> cobjectData) {
    _items.clear();

    try {
      if (cobjectData == null) {
        return null;
      }
      final List<Cobject> loadedCobjects = [];
      cobjectData[0]["cobjects"].forEach((cobjectsJson) {
        loadedCobjects.add(Question.fromJson(cobjectsJson));
      });
      _cobjectList.addAll(loadedCobjects);
      // notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
