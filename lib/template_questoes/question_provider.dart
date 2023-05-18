import './model.dart';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/all.dart';

// template code, disciplina, texto da questão, alternativas e qual é a certa
// tem áudio? tem imagem? <- perguntas e respostas

class Cobjects {
  Cobjects();

  final List<Cobject> _cobjectList = [];
  List<Cobject> _items = [];

  List<Cobject> get items => _cobjectList;

  void fetchCobjects(List<dynamic>? cobjectData) {
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
