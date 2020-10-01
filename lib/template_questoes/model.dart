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
  List<String> pieceImages;
  String firstLayertype;
  String secondLayertype;
  String thirdLayertype;

  Question({
    this.questionText,
    this.questionImage,
    this.firstItem,
    this.firstItemImage,
    this.secondItem,
    this.secondItemImage,
    this.thirdItem,
    this.thirdItemImage,
    this.pieceImages,
    this.firstLayertype,
    this.secondLayertype,
    this.thirdLayertype,
  });

  List<String> question = ['hey', 'hoy'];
  List addList(Map<String, dynamic> json) {
    // question[0] = json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
    //     ["groups"]["1"]["elements"][0]["generalProperties"][7]["value"];
    // question.add(json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
    //     ["groups"]["2"]["elements"][0]["generalProperties"][7]["value"]);
    // question.add(json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
    //     ["groups"]["3"]["elements"][0]["generalProperties"][7]["value"]);
    // return [...question];
  }

  // factory Question.fromJson(Map<String, dynamic> json) => Question(
  static Question fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json["cobjects"][0]["screens"][0]["piecesets"][0]["groups"]
          ["1"]["elements"][0]["generalProperties"][1]["value"],
      questionImage: json["cobjects"][0]["screens"][0]["piecesets"][0]["groups"]
          ["1"]["elements"][1]["generalProperties"][3]["value"],
      firstItem: json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
          ["groups"]["1"]["elements"][0]["generalProperties"][1]["value"],
      // firstItemImage: json["cobjects"][0]["screens"][0]["piecesets"][0]
      //         ["pieces"][0]["groups"]["1"]["elements"][0]["generalProperties"]
      //     [7]["value"],
      secondItem: json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
          ["groups"]["2"]["elements"][0]["generalProperties"][1]["value"],
      // secondItemImage: json["cobjects"][0]["screens"][0]["piecesets"][0]
      //         ["pieces"][0]["groups"]["2"]["elements"][0]["generalProperties"][7]
      //     ["value"],
      thirdItem: json["cobjects"][0]["screens"][0]["piecesets"][0]["pieces"][0]
          ["groups"]["3"]["elements"][0]["generalProperties"][1]["value"],
      thirdItemImage: json["cobjects"][0]["screens"][0]["piecesets"][0]
              ["pieces"][0]["groups"]["3"]["elements"][0]["generalProperties"]
          [7]["value"],
      firstLayertype: json["cobjects"][0]["screens"][0]["piecesets"][0]
              ["pieces"][0]["groups"]["1"]["elements"][0]
          ["pieceElement_Properties"]["layertype"],
      secondLayertype: json["cobjects"][0]["screens"][0]["piecesets"][0]
              ["pieces"][0]["groups"]["2"]["elements"][0]
          ["pieceElement_Properties"]["layertype"],
      thirdLayertype: json["cobjects"][0]["screens"][0]["piecesets"][0]
              ["pieces"][0]["groups"]["3"]["elements"][0]
          ["pieceElement_Properties"]["layertype"],
      pieceImages: Question().addList(json),
    );
  }
}
