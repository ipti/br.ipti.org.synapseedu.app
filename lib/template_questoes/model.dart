import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:elesson/share/question_widgets.dart';

import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

// Modelo para os cobjects e questões, além dos métodos para serialização do json recebido do servidor.

class Answer {
  Future<dynamic> sendAnswerToApi(String pieceId, bool isCorrect, int finalTime, {int intervalResolution, String groupId, String value}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String actor_id = await prefs.getString('actor_id');

    // Response response;
    // BaseOptions options =
    //     BaseOptions(baseUrl: "http://app.elesson.com.br/api-synapse");
    // var dio = Dio(options);
    // FormData form = FormData.fromMap({
    //   "mode": "proficiency",
    //   "piece_id": "2325",
    //   "group_id": "null",
    //   "actor_id": "5",
    //   "final_time": "1600718031765",
    //   "interval_resolution": "187230",
    //   "value": "Testando",
    //   "iscorrect": "false"
    // });
    // try {
    //   response = await dio.post(
    //     "/synapse/performance/actor/save",
    //     data: form,
    //   );
    // } catch (e) {
    //   print(e.toString());
    // }
    print('======');
    print("value:" +value);
    print("""{
        "mode": "evaluation",
        "piece_id": "$pieceId",
        "group_id": "$groupId",
        "actor_id": "$actor_id",
        "final_time": "$finalTime",
        "interval_resolution": "$intervalResolution",
        "iscorrect": "$isCorrect"
      }""");



    try {
      var response = await http.post("${API_URL}performance/actor/save", body: {
        "mode": "evaluation",
        "piece_id": "$pieceId",
        "group_id": "$groupId",
        "actor_id": "$actor_id",
        "final_time": "$finalTime",
        "interval_resolution": "$intervalResolution",
        "value": value != null ? value : "",
        "iscorrect": "$isCorrect"
      }, headers: {
        HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"
      });
      print("response: ${response.statusCode}");
      print("Enviado: $value and $groupId");
      print("STATUS_CODE: ${response.statusCode}");
      print("BODY: ${response.body}");
    } catch (e) {
      print(e);
    }
  }
}

class ConversorVoiceToText {
  Future<dynamic> speechToTextAzure(File file) async {
    print("solicitação");
    final bytes = file.readAsBytesSync();

    var headers = {'Ocp-Apim-Subscription-Key': 'b21db0729fc14cc7b6de72e1f44322dd', 'Content-Type': 'audio/wav'};

    var response;
    Map<String, dynamic> responseBody;
    var recognizedVoiceText;

    try {
      response = await http.post(
        "https://brazilsouth.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=pt-BR",
        body: bytes,
        headers: headers,
      );

      // The response body is a string that needs to be decoded as a json in order to get the extract the text.
      responseBody = jsonDecode(response.body);
      recognizedVoiceText = responseBody["DisplayText"];
      print(recognizedVoiceText);
    } catch (e) {
      print('Error: ${e.toString()}');
      recognizedVoiceText = "Something went wrong";
    }

    return recognizedVoiceText;
  }

  Future<dynamic> conversorVoice(String audioPath, context) async {
    //Response response;

    ByteData audioBytes = await DefaultAssetBundle.of(context).load('assets/audio/audio.wav');

    print("CAMINHO ENVIADO: $audioPath ${audioBytes.toString()}");

    var headers = {'Ocp-Apim-Subscription-Key': 'b21db0729fc14cc7b6de72e1f44322dd', 'Content-Type': 'audio/wav'};
    String retorno;
    try {
      // var response = await http.post(
      //   "https://brazilsouth.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=pt-BR",
      //   body: {
      //     "data-binary": audioBytes,
      //   },
      //   // headers: {
      //   //   HttpHeaders.authorizationHeader: "b21db0729fc14cc7b6de72e1f44322dd",
      //   //   'Content-type': "audio/wav",
      //   // },
      //   headers: headers,
      // );
      // print('Olha: ${response.statusCode}');

      // var headers = {
      //   'Ocp-Apim-Subscription-Key': 'b21db0729fc14cc7b6de72e1f44322dd',
      //   'Content-Type': 'audio/wav'
      // };
      // var request = http.Request(
      //     'POST',
      //     Uri.parse(
      //         'https://brazilsouth.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=pt-BR'));
      // request.body = audioBytes.toString();

      // request.headers.addAll(headers);

      // http.StreamedResponse response = await request.send();

      // if (response.statusCode == 200) {
      //   print(await response.stream.bytesToString());
      // } else {
      //   print(response.reasonPhrase);
      // }

      var response = await Dio().post(
        "https://brazilsouth.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=pt-BR",
        data: {
          "data-binary": audioBytes,
        },
        options: Options(
            headers: {"Ocp-Apim-Subscription-Key": "b21db0729fc14cc7b6de72e1f44322dd"},
            //{HttpHeaders.authorizationHeader: {"Ocp-Apim-Subscription-Key": "b21db0729fc14cc7b6de72e1f44322dd"}},
            contentType: "audio/wav"),
      );
      print(response.statusCode);

      // var request = http.MultipartRequest(
      //     'POST',
      //     Uri.parse(
      //         "https://brazilsouth.stt.speech.microsoft.com/speech/recognition/conversation/cognitiveservices/v1?language=pt-BR"));
      // request.files.add(await http.MultipartFile.fromPath('audio[]', audioPath,
      //     contentType: MediaType.parse('audio/wav')));
      // request.headers.addAll(headers);
      // print("enviar");
      // print(request.headers);
      // var res = await request.send();
      // print("FOI? ${res.statusCode}");
    } catch (e) {
      print('Erro: ${e.toString()}');
    }
    // print(re)
    //print("TEXTO DO AUDIO: $");
    // print("STATUS_CODE: ${response.statusCode}");
  }
}

class Cobject {
  String description;
  String descriptionSound;
  String discipline;
  String totalPieces;
  List<Question> questions;
  String year;

  Cobject({
    this.description,
    this.descriptionSound,
    this.discipline,
    this.totalPieces,
    this.questions = const [],
    this.year,
  });
}

class Question {
  String pieceId;
  Map<String, String> header;
  Map<String, dynamic> pieces;

  Question({
    this.pieceId,
    this.header = const {},
    this.pieces = const {},
  });

  List<String> questionItems = [];
  List<String> questionImages = [];

  List<String> addTextItems(Map<String, dynamic> json) {
    //A implementação mudará quando tiver um exemplo sem bugs do json
    json.forEach((key, value) {
      questionItems.add(value["elements"][0]["generalProperties"][1]["value"]);
    });
    return questionItems;
  }

  List addList(Map<String, dynamic> json) {
    //A implementação mudará quando tiver um exemplo sem bugs do json
    json.forEach((key, value) {
      if (value["elements"][0]["generalProperties"].length > 2) {
        questionImages.add(value["elements"][0]["generalProperties"][7]["value"]);
      }
    });
    return questionImages;
  }

  String src;

  Map<String, String> questionMultimediaSearch(Map<String, dynamic> json) {
    Map<String, String> srcMap = {
      "image": "",
      "sound": "",
      "text": "",
      "description": "",
    };
    // srcMap.update("description", (value) => json["cobjects"][0]["description"]);
    for (var elements in json["piecesets"][0]["groups"]["1"]["elements"]) {
      if (elements["type"] == "multimidia") {
        elements["generalProperties"].forEach((pair) {
          if (pair["name"] == "src") {
            src = pair["value"];
          }
          if (pair["name"] == "library_type") {
            if (pair["value"] == "image") {
              srcMap.update("image", (value) => src);
            } else {
              srcMap.update("sound", (value) => src);
            }
          }
        });
        // break;
      } else if (elements["type"] == "text") {
        srcMap.update("text", (value) => elements["generalProperties"][1]["value"]);
        // src = "Não funcionou";
      }
    }
    // if (imageLink != null) {
    //   print("entroukkkk");
    //   return imageLink;
    // }
    return srcMap;
  }

  Map<String, dynamic> questionItemSearch(Map<String, dynamic> groups) {
    // Esse método busca pelos items de resposta na questão e retorna um mapa com os atributos:
    // Lista de Map<grouping,elements> que contém uma lista dos groupings das questões e seus respectivos
    // elementos.
    // Também foi adicionado uma chave correctAnswer que obtém o grouping correto da questão, além de um
    // uma chave composition que indica se na questão tem som, imagem e texto nos itens.

    Map<String, dynamic> itemsMap = {
      // "firstItem": {},
      // "secondItem": {},
      // "thirdItem": {},
      "correctAnswer": 0,
      "composition": {
        "text": false,
        "image": false,
        "sound": false,
      }
    };

    List<Map<String, String>> item = [
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""}
    ];

    var index = 0;
    groups.forEach((group, elements) {
      elements.forEach((element, elementProperty) {
        for (var value in elementProperty) {
          if (value["pieceElement_Properties"]["layertype"] == "Acerto") {
            itemsMap["correctAnswer"] = int.parse(value["pieceElement_Properties"]["grouping"]);
          }
          // A parte abaixo começa a testar o tipo do item presente em elements para atribuir o caminho do item
          // na respectiva chave. Assim que encontrar determinado tipo de elemento, ele também atualiza a
          // chave que indica a composição da questão para verdadeiro.

          if (value["type"] == "text") {
            item[index].update("text", (val) => value["generalProperties"][1]["value"]);
            if (itemsMap["composition"]["text"] == false) itemsMap["composition"]["text"] = true;
          } else if (value["type"] == "multimidia") {
            // O pair abaixo representa o par com chaves 'name' e 'value' característicos do generalProperties.
            for (var pair in value["generalProperties"]) {
              if (pair["name"] == "src") {
                if (pair["value"].endsWith(".mp3")) {
                  // print('MP3: ${pair["value"]}');
                  item[index].update("sound", (val) => pair["value"]);
                  if (itemsMap["composition"]["sound"] == false) itemsMap["composition"]["sound"] = true;
                } else {
                  item[index].update("image", (val) => pair["value"]);
                  if (itemsMap["composition"]["image"] == false) itemsMap["composition"]["image"] = true;
                }
              }
            }
          }
        }
      });

      itemsMap.putIfAbsent(group, () => item[index]);
      index++;
    });
    return itemsMap;
  }

  // factory Question.fromJson(Map<String, dynamic> json) => Question(

  String descriptionSound(Map<String, dynamic> elements) {
    if (elements["type"] == 'multimidia' && elements['generalProperties'].length == 5 && elements['generalProperties'][2]['name'] == 'src') {
      print('HEY SOM: ${elements['generalProperties'][2]['value']}');
      return elements['generalProperties'][2]['value'];
    }
    return '';
  }

  List<Question> insertQuestionList(Map<String, dynamic> cobject) {
    List<Question> questionList = [];
    cobject["screens"].forEach((screens) {
      questionList.add(Question(
        pieceId: screens['piecesets'][0]['pieces'][0]['id'],
        header: Question().questionMultimediaSearch(screens),
        pieces: Question().questionItemSearch(screens["piecesets"][0]["pieces"][0]["groups"]),
      ));
    });
    return questionList;
  }

  static Cobject fromJson(Map<String, dynamic> json) {
    // Map<String, String> mapa = Question().questionMultimediaSearch(json);

    // List<Question> addQuestion = [];

    return Cobject(
      description: json["description"],
      descriptionSound: json['elements'].isNotEmpty ? Question().descriptionSound(json['elements'][0]) : '',
      discipline: json["discipline"],
      totalPieces: json["total_pieces"],
      questions: Question().insertQuestionList(json),
      year: json["year"],
    );
  }
}
