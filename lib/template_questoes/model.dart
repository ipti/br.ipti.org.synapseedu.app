import 'dart:convert';

class Cobject {
  String description;
  List<Question> questions;

  Cobject({
    this.description,
    this.questions = const [],
  });
}

class Question {
  String questionImage;
  Map<String, String> header;
  Map<String, dynamic> pieces;

  Question({
    this.questionImage,
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
        questionImages
            .add(value["elements"][0]["generalProperties"][7]["value"]);
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
        srcMap.update(
            "text", (value) => elements["generalProperties"][1]["value"]);
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
            itemsMap["correctAnswer"] =
                int.parse(value["pieceElement_Properties"]["grouping"]);
          }
          // A parte abaixo começa a testar o tipo do item presente em elements para atribuir o caminho do item
          // na respectiva chave. Assim que encontrar determinado tipo de elemento, ele também atualiza a
          // chave que indica a composição da questão para verdadeiro.

          if (value["type"] == "text") {
            item[index].update(
                "text", (val) => value["generalProperties"][1]["value"]);
            if (itemsMap["composition"]["text"] == false)
              itemsMap["composition"]["text"] = true;
          } else if (value["type"] == "multimidia") {
            // O pair abaixo representa o par com chaves 'name' e 'value' característicos do generalProperties.
            for (var pair in value["generalProperties"]) {
              if (pair["name"] == "src") {
                if (pair["value"].endsWith(".mp3")) {
                  item[index].update("sound", (val) => pair["value"]);
                  if (itemsMap["composition"]["sound"] == false)
                    itemsMap["composition"]["sound"] = true;
                } else {
                  item[index].update("image", (val) => pair["value"]);
                  if (itemsMap["composition"]["image"] == false)
                    itemsMap["composition"]["image"] = true;
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

  List<Question> insertQuestionList(Map<String, dynamic> cobject) {
    List<Question> questionList = [];

    cobject["screens"].forEach((screens) {
      questionList.add(Question(
        header: Question().questionMultimediaSearch(screens),
        pieces: Question()
            .questionItemSearch(screens["piecesets"][0]["pieces"][0]["groups"]),
      ));
    });
    return questionList;
  }

  static Cobject fromJson(Map<String, dynamic> json) {
    // Map<String, String> mapa = Question().questionMultimediaSearch(json);

    // List<Question> addQuestion = [];

    return Cobject(
      description: json["description"],
      questions: Question().insertQuestionList(json),
    );

    // return Question(
    //   questionImage: mapa["image"],
    //   header: Question().questionMultimediaSearch(json),
    //   pieces: Question()
    //       .questionItemSearch(json["piecesets"][0]["pieces"][0]["groups"]),
    // );
  }
}
