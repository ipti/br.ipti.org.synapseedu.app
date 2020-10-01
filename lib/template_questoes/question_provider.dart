import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
// import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import './model.dart';
import 'package:dio/dio.dart';

// template code, disciplina, texto da questão, alternativas e qual é a certa
// tem áudio? tem imagem? <- perguntas e respostas

//lembrar de descomentar notifyListeners
// class Cobjects with ChangeNotifier {
class Cobjects extends StateNotifier<List<Cobject>> {
  Cobjects() : super([]);
// class Cobjects extends ChangeNotifier {
  int _assuntoId;
  final List<Question> _questionList = [];
  List<Question> _items = [
    // Assunto(
    //   id: 1,
    //   titulo: 'Gengiva',
    // ),
    // Assunto(
    //   id: 2,
    //   titulo: 'Dente',
    // ),
    // Assunto(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Assunto(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  // List<Assunto> get items {
  //   // if (_showFavoritesOnly == true){
  //   //   return _items.where((prodItem) => prodItem.isFavorite).toList();
  //   // }
  //   return [..._items];
  // }

  // List<Question> get items {
  //   return [..._questionList];
  // }

  List<Question> get items => UnmodifiableListView(_questionList);

  // int get assuntoId {
  //   return assuntoId;
  // }

  String mockJson = '''[ {
  "valid" : true,
  "error" : [ "Num Cobjects: 1" ],
  "cobjects" : [ {
    "cobject_id" : "3902",
    "description" : "",
    "cobject_type" : "Atividade",
    "template_name" : "Multipla Escolha",
    "template_code" : "MTE",
    "format_code" : "Vertical",
    "interative_code" : "Click",
    "theme" : null,
    "status" : "on",
    "goal" : "CONVERTER AS UNIDADES DE MEDIDAS: CAPACIDADE, VOLUME E SUPERFÍCIE",
    "goal_id" : "10107",
    "degree_name" : "Fundamental - 5º ANO/2",
    "stage" : "18",
    "year" : "5",
    "grade" : "2",
    "degree_parent" : "Fundamental Menor - 5º ANO",
    "discipline" : "Matemática",
    "content" : "Problemas",
    "content_parent_name" : null,
    "modality" : "Sonoro",
    "content_parent" : null,
    "id" : "1",
    "total_pieces" : "11",
    "screens" : [ {
      "id" : "8619",
      "cobject_id" : "3902",
      "oldID" : null,
      "position" : "0",
      "piecesets" : [ {
        "id" : "9007",
        "description" : "",
        "groups" : {
          "1" : {
            "elements" : [ {
              "id" : "61908",
              "piecesetElementID" : "17521",
              "type" : "text",
              "generalProperties" : [ {
                "name" : "language",
                "value" : "português"
              }, {
                "name" : "text",
                "value" : "Uma piscina olímpica tem 200 dm³ de volume. Quantos decâmetros cúbicos tem essa piscina?"
              } ],
              "piecesetElement_Properties" : {
                "grouping" : "1",
                "layertype" : null
              }
            }, {
              "id" : "61909",
              "piecesetElementID" : "17522",
              "type" : "multimidia",
              "generalProperties" : [ {
                "name" : "library_id",
                "value" : "36709"
              }, {
                "name" : "width",
                "value" : "1240"
              }, {
                "name" : "height",
                "value" : "1240"
              }, {
                "name" : "src",
                "value" : "30b987599888ca2f05669224378280ca.jpg"
              }, {
                "name" : "extension",
                "value" : "jpg"
              }, {
                "name" : "alias",
                "value" : "Pedro_Pensando_1"
              }, {
                "name" : "library_type",
                "value" : "image"
              } ],
              "piecesetElement_Properties" : {
                "grouping" : "1",
                "layertype" : null
              }
            } ]
          }
        },
        "pieces" : [ {
          "id" : "9112",
          "name" : null,
          "description" : null,
          "groups" : {
            "1" : {
              "elements" : [ {
                "generalProperties" : [ {
                  "name" : "language",
                  "value" : "português"
                }, {
                  "name" : "text",
                  "value" : "0,0002 dam³"
                } ],
                "id" : "61910",
                "pieceElementID" : "44878",
                "pieceElement_Properties" : {
                  "grouping" : "1",
                  "layertype" : "Acerto"
                },
                "type" : "text"
              } ]
            },
            "2" : {
              "elements" : [ {
                "generalProperties" : [ {
                  "name" : "language",
                  "value" : "português"
                }, {
                  "name" : "text",
                  "value" : "0,02 dam³"
                } ],
                "id" : "61911",
                "pieceElementID" : "44879",
                "pieceElement_Properties" : {
                  "grouping" : "2",
                  "layertype" : "Erro"
                },
                "type" : "text"
              } ]
            },
            "3" : {
              "elements" : [ {
                "generalProperties" : [ {
                  "name" : "language",
                  "value" : "português"
                }, {
                  "name" : "text",
                  "value" : "20 dam³"
                }, {
                  "name" : "width",
                  "value" : "283"
                }, {
                  "name" : "height",
                  "value" : "213"
                }, {
                  "name" : "content",
                  "value" : "OBJECT"
                }, {
                  "name" : "nstyle",
                  "value" : "Infantil"
                }, {
                  "name" : "extension",
                  "value" : "jpg"
                }, {
                  "name" : "src",
                  "value" : "803.jpg"
                }, {
                  "name" : "library_type",
                  "value" : "image"
                } ],
                "id" : "61912",
                "pieceElementID" : "44880",
                "pieceElement_Properties" : {
                  "grouping" : "3",
                  "layertype" : "Erro"
                },
                "type" : "text"
              } ]
            },
            "4" : {
              "elements" : [ {
                "generalProperties" : [ {
                  "name" : "language",
                  "value" : "português"
                }, {
                  "name" : "text",
                  "value" : "2 000 dam³"
                }, {
                  "name" : "width",
                  "value" : "303"
                }, {
                  "name" : "height",
                  "value" : "286"
                }, {
                  "name" : "color",
                  "value" : "COLOR"
                }, {
                  "name" : "content",
                  "value" : "OBJECT"
                }, {
                  "name" : "nstyle",
                  "value" : "Infantil"
                }, {
                  "name" : "extension",
                  "value" : "jpg"
                }, {
                  "name" : "src",
                  "value" : "409.jpg"
                }, {
                  "name" : "library_type",
                  "value" : "image"
                } ],
                "id" : "61913",
                "pieceElementID" : "44881",
                "pieceElement_Properties" : {
                  "grouping" : "4",
                  "layertype" : "Erro"
                },
                "type" : "text"
              } ]
            }
          },
          "types_elements" : [ ]
        } ],
        "template_code" : "PRE"
      } ]
    }],
    "elements" : [ ]
  } ]
} ]''';

  // void getImageFromApi(String imageName) async {
  //   try {
  //     Response response = await Dio()
  //         .get("http://dev.elesson.com.br:8080/library/image/" + imageName);
  //     print(response.data);
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // Future<void> fetchCobjects() async {
  void fetchCobjects() {
    // final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    // var url = 'https://odonto-api-ufs.herokuapp.com/api/Assuntos';
    try {
      // final response = await http.get(url);
      // print(response.body);
      // final extractedData = json.decode(response.body) as Map<int, dynamic>;
      // var extractedData = json.decode(response.body) as List<dynamic>;
      var extractedData = json.decode(mockJson) as List<dynamic>;
      if (extractedData == null) {
        return null;
      }
      // print(extractedData[0]["cobjects"][0]["screens"][0]["piecesets"][0]
      //         ["groups"]
      //     .length);
      final List<Cobject> loadedCobject = [];
      final List<Screen> loadedScreen = [];
      final List<Question> loadedQuestion = [];
      // extractedData.forEach((json) {
      //   // print(json["cobjects"][0]["screens"][0]);
      //   loadedCobject.add(Cobject(
      //     templateCode: json["cobjects"][0]["template_code"],
      //     discipline: json["cobjects"][0]["discipline"],
      //     modality: json["cobjects"][0]["modality"],
      //     totalPieces: int.parse(json["cobjects"][0]["total_pieces"]),
      //     screen: Screen.fromJson(json["cobjects"][0]["screens"][0]),
      //   ));
      // });
      extractedData.forEach((json) {
        // print(json["cobjects"][0]["screens"][0]);
        loadedQuestion.add(Question.fromJson(json));
      });
      // print(loadedQuestion[0].questionText);
      // print(loadedQuestion[0].questionImage);
      // print(loadedQuestion[0].firstItem);
      // print(loadedQuestion[0].secondItem);
      // print(loadedQuestion[0].thirdItem);
      // print(loadedQuestion[0].thirdItemImage);
      // print(loadedQuestion[0].firstLayertype);
      // print(loadedQuestion[0].secondLayertype);
      // print(loadedQuestion[0].thirdLayertype);

      // url =
      //     'https://fluttershop-app.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      // final List<Assunto> loadedCobject = [];
      // extractedData.forEach((prodId, prodData) {
      //   loadedCobject.add(Assunto(
      //     id: prodId,
      //     titulo: prodData['titulo'],
      //   ));
      // });
      // _assuntoId = loadedCobject[0].id;
      // _items = loadedQuestion;
      // _questionList = loadedQuestion;
      _questionList.addAll(loadedQuestion);
      // print(loadedCobject[0].screen.piecesets.piecesetId);

      // notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  // void offlineAssuntos([bool filterByUser = false]) {
  //   // final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

  //   final List<Assunto> loadedAssuntos = [];
  //   loadedAssuntos.add(Assunto(
  //     id: 5,
  //     titulo: 'Radiologia',
  //     dataHoraCriacao: DateTime.parse('25/06/2020'),
  //     dataHoraModificacao: DateTime.parse('25/06/2020'),
  //     // topicos: assunto['topicos'],
  //   ));

  //   _items = loadedAssuntos;
  //   notifyListeners();
  // }

  // Future<void> addAssunto(Assunto assunto) async {
  //   // final url = 'https://fluttershop-app.firebaseio.com/Assuntos.json?auth=$authToken';

  //   // try {
  //   //   final response = await http.post(
  //   //     url, body: json.encode({
  //   //       'id': assunto.id,
  //   //       'titlo': assunto.titulo,
  //   //       'imageUrl': assunto.imageUrl,
  //   //       'price': assunto.price,
  //   //       'creatorId': userId,
  //   //     }),
  //   //   );

  //   //   final newAssunto = Assunto(
  //   //     title: product.title,
  //   //     description: product.description,
  //   //     price: product.price,
  //   //     imageUrl: product.imageUrl,
  //   //     id: json.decode(response.body)['name'],
  //   //   );

  //   //   _items.add(newAssunto);
  //   //   notifyListeners();

  //   // } catch (error) {
  //   //   throw error;
  //   // }
  //   //   // print(json.decode(response.body));
  // }

  // Future<void> updateAssunto(String id, Assunto newAssunto) async {
  //   /*final prodIndex = _items.indexWhere((prod) => prod.id == id);
  //   if (prodIndex >= 0) {
  //     final url = 'https://fluttershop-app.firebaseio.com/products/$id.json?auth=$authToken';
  //     await http.patch(
  //       url,
  //       body: json.encode({
  //         'title': newAssunto.title,
  //         'description': newAssunto.description,
  //         'imageUrl': newAssunto.imageUrl,
  //         'price': newAssunto.price,
  //       })
  //     );

  //     _items[prodIndex] = newAssunto;
  //     notifyListeners();
  //   }*/
  // }

  // Future<void> deleteAssunto(String id) async {
  //   // final url = 'https://fluttershop-app.firebaseio.com/products/$id.json?auth=$authToken';
  //   // final existingAssuntoIndex = _items.indexWhere((prod) => prod.id == id);
  //   // var existingAssunto = _items[existingAssuntoIndex];

  //   // _items.removeAt(existingAssuntoIndex);
  //   // notifyListeners();

  //   // final response = await http.delete(url);

  //   // if (response.statusCode >= 400) {
  //   //   _items.insert(existingAssuntoIndex, existingAssunto);
  //   //   notifyListeners();
  //   //   throw HttpException('Could not delete product.');
  //   // }

  //   // existingAssunto = null;
  // }
}
