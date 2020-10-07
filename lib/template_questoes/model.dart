import 'dart:convert';

Cobject userFromJson(String str) => Cobject.fromJson(json.decode(str));

String userToJson(Cobject data) => json.encode(data.toJson());

class Cobject {
  String templateCode;
  String discipline;
  String modality;
  int totalPieces;
  Screen screen;

  Cobject({
    this.templateCode,
    this.discipline,
    this.modality,
    this.totalPieces,
    this.screen,
  });

  factory Cobject.fromJson(Map<String, dynamic> json) => Cobject(
        templateCode: json["template_code"],
        discipline: json["discipline"],
        modality: json["modality"],
        totalPieces: int.parse(json["total_pieces"]),
        screen: Screen.fromJson(json["screen"]),
      );

  Map<String, dynamic> toJson() => {
        "template_code": templateCode,
        "discipline": discipline,
        "modality": modality,
        "total_pieces": totalPieces.toString(),
        "screen": screen.toJson(),
      };
}

class Screen {
  String id;
  String cbojectId;
  String position;
  Pieceset piecesets;

  Screen({
    this.id,
    this.cbojectId,
    this.position,
    this.piecesets,
  });

  factory Screen.fromJson(Map<String, dynamic> json) => Screen(
        id: json["id"],
        cbojectId: json["cobject_id"],
        position: json["position"],
        piecesets: Pieceset.fromJson(json["piecesets"][0]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cboject_id": cbojectId,
        "position": position,
        // "piecesets": piecesets.toJson(),
      };
}

class Pieceset {
  String piecesetId;
  Groups groups;

  Pieceset({
    this.piecesetId,
    this.groups,
  });

  factory Pieceset.fromJson(Map<String, dynamic> json) => Pieceset(
        piecesetId: json["id"],
        groups: Groups.fromJson(json["groups"]),
      );
  // Pode usar o .length em groups para saber o número de chaves.
  // Assim é possível criar a lista de elementos

  Map<String, dynamic> toJson() => {
        "id": piecesetId,
        // "groups": groups,
      };
}

class Groups {
  // List<Elements> elements;

  Groups({
    // this.elements,
    String mock,
  });

  factory Groups.fromJson(Map<String, dynamic> json) => Groups(
      // json.forEach((key, value) {
      //   elements.add(Elements(
      //     name: json["cobjects"][0]["template_code"],
      //   ));
      // })
      // elements: elements.re,
      );

  Map<String, dynamic> toJson() => {};
}

// class Elements {
//   String name;

//   Elements({
//     this.name,
//   });

//   factory Elements.addFromList()

//   factory Elements.fromJson(Map<String, dynamic> json) => Elements(
//         name: json["name"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//       };
// }

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

  String questionTextSearch(Map<String, dynamic> json) {
    String text;
    for (var elements in json["cobjects"][0]["screens"][0]["piecesets"][0]
        ["groups"]["1"]["elements"]) {
      if (elements["type"] == "text") {
        text = elements["generalProperties"][1]["value"];
        break;
      } else {
        text = "Não funcionou";
      }
    }
    return text;
  }

  String src;
  Map<String, String> questionMultimediaSearch(Map<String, dynamic> json) {
    Map<String, String> srcMap = {
      "image": "",
      "sound": "",
      "text": "",
      "description": "",
    };
    srcMap.update("description", (value) => json["cobjects"][0]["description"]);
    for (var elements in json["cobjects"][0]["screens"][0]["piecesets"][0]
        ["groups"]["1"]["elements"]) {
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
    String src;
    List<Map<String, String>> item = [
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""},
      {"text": "", "sound": "", "image": ""}
    ];
    Map<String, String> map = {};
    var index = 0;
    groups.forEach((group, elements) {
      print(group);
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
  static Question fromJson(Map<String, dynamic> json) {
    Map<String, String> mapa = Question().questionMultimediaSearch(json);
    return Question(
      questionImage: mapa["image"],
      header: Question().questionMultimediaSearch(json),
      pieces: Question().questionItemSearch(json["cobjects"][0]["screens"][0]
          ["piecesets"][0]["pieces"][0]["groups"]),
    );
  }
}
