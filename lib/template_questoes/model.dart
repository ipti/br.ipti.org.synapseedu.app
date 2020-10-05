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
  String questionText;
  String questionImage;
  String firstItem;
  String firstItemImage;
  String secondItem;
  String secondItemImage;
  String thirdItem;
  String thirdItemImage;
  List<String> piecesItem;
  List<String> piecesImage;
  String firstLayertype;
  String secondLayertype;
  String thirdLayertype;
  Map<String, String> header;

  Question({
    this.questionText,
    this.questionImage,
    this.firstItem,
    this.firstItemImage,
    this.secondItem,
    this.secondItemImage,
    this.thirdItem,
    this.thirdItemImage,
    this.piecesItem,
    this.piecesImage,
    this.firstLayertype,
    this.secondLayertype,
    this.thirdLayertype,
    this.header = const {},
  });
  List<String> questionItems = [];
  List<String> questionImages = [];
  String imageLink = "";
  String soundLink = "";

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
      // print(elements["type"]);
      if (elements["type"] == "text") {
        // print(elements["type"]);
        text = elements["generalProperties"][1]["value"];
        // print('Funcionou: $text');
        break;
      } else {
        // print('Entrou aqui: ${elements["generalProperties"][1]["value"]}');
        text = "Não funcionou";
      }
    }
    return text;
  }

  Map<String, String> map = {
    "imagem": "",
    "som": "",
  };
  String src;
  Map<String, String> questionMultimediaSearch(Map<String, dynamic> json) {
    Map<String, String> srcMap = {
      "image": "",
      "sound": "",
    };
    for (var elements in json["cobjects"][0]["screens"][0]["piecesets"][0]
        ["groups"]["1"]["elements"]) {
      print(elements["type"]);
      if (elements["type"] == "multimidia") {
        elements["generalProperties"].forEach((pair) {
          if (pair["name"] == "src") {
            src = pair["value"];
            print("Atribuiu: ${pair["value"]}");
          }
          if (pair["name"] == "library_type") {
            if (pair["value"] == "image") {
              map["imagem"] = src;
              imageLink = src;
              srcMap.update("image", (value) => src);
              print('É imagem: $imageLink');
              return imageLink;
            } else {
              soundLink = src;
              map["som"] = src;
              print('É som: $soundLink');
              srcMap.update("sound", (value) => src);
              return soundLink;
            }
          }
        });
        // print(elements["type"]);
        // src = elements["generalProperties"][1]["value"];
        // print('Funcionou: $src');
        // break;
      } else {
        print('Entrou aqui: ${elements["generalProperties"][1]["value"]}');
        // src = "Não funcionou";
      }
      print("executou");
    }
    // print('Interno: ${imageLink} or $soundLink');
    print('Retornou: $src');
    // if (imageLink != null) {
    //   print("entroukkkk");
    //   return imageLink;
    // }
    return srcMap;
  }

  // factory Question.fromJson(Map<String, dynamic> json) => Question(
  static Question fromJson(Map<String, dynamic> json) {
    Map<String, String> mapa = Question().questionMultimediaSearch(json);
    print('Funciona: $mapa');
    return Question(
      // questionText: json["cobjects"][0]["screens"][0]["piecesets"][0]["groups"]
      //     ["1"]["elements"][0]["generalProperties"][1]["value"],
      questionText: Question().questionTextSearch(json),
      // questionImage: Question().questionMultimediaSearch(json),
      questionImage: mapa["image"],
      header: Question().questionMultimediaSearch(json),
      // json["cobjects"][0]["screens"][0]["piecesets"][0]["groups"]["1"]
      //         ["elements"]
      //     .forEach((value) {
      //   if (value["type"] == "text") {
      //     questionText:
      //     value["generalProperties"][1]["value"];
      //   }
      // }),
      // questionImage: json["cobjects"][0]["screens"][0]["piecesets"][0]["groups"]
      //     ["1"]["elements"][1]["generalProperties"][3]["value"],
      // firstItem: json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
      //     ["groups"]["1"]["elements"][0]["generalProperties"][1]["value"],
      // // firstItemImage: json["cobjects"][0]["screens"][0]["piecesets"][0]
      // //         ["pieces"][0]["groups"]["1"]["elements"][0]["generalProperties"]
      // //     [7]["value"],
      // secondItem: json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
      //     ["groups"]["2"]["elements"][0]["generalProperties"][1]["value"],
      // // secondItemImage: json["cobjects"][0]["screens"][0]["piecesets"][0]
      // //         ["pieces"][0]["groups"]["2"]["elements"][0]["generalProperties"][7]
      // //     ["value"],
      // thirdItem: json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
      //     ["groups"]["3"]["elements"][0]["generalProperties"][1]["value"],
      // // thirdItemImage: json["cobjects"][0]["screens"][0]["piecesets"][0]
      // //         ["pieces"][0]["groups"]["3"]["elements"][0]["generalProperties"]
      // //     [7]["value"],
      // firstLayertype: json["cobjects"][0]["screens"][0]["piecesets"][0]
      //         ["pieces"][0]["groups"]["1"]["elements"][0]
      //     ["pieceElement_Properties"]["layertype"],
      // secondLayertype: json["cobjects"][0]["screens"][0]["piecesets"][0]
      //         ["pieces"][0]["groups"]["2"]["elements"][0]
      //     ["pieceElement_Properties"]["layertype"],
      // thirdLayertype: json["cobjects"][0]["screens"][0]["piecesets"][0]
      //         ["pieces"][0]["groups"]["3"]["elements"][0]
      //     ["pieceElement_Properties"]["layertype"],
      // piecesImage: Question().addList(json["cobjects"][0]["screens"][0]
      //     ["piecesets"][0]["pieces"][0]["groups"]),
      // piecesItem: (Question().addTextItems(json["cobjects"][0]["screens"][0]
      //     ["piecesets"][0]["pieces"][0]["groups"])),
      // piecesItem.addAll(Question().addTextItems(json["cobjects"][0]["screens"][0]
      // ["piecesets"][0]["pieces"][0]["groups"])),
    );
  }
}
