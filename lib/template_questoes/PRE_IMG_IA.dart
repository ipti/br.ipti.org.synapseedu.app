import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:elesson/template_questoes/model.dart';

// final cobjectProvider = Provider<Cobjects>((ref) {
//   return Cobjects();
// });

// ignore: must_be_immutable
class PreImgIa extends StatefulWidget {
  static const routeName = '/PRE_IMG_IA';

  @override
  _PreImgIaState createState() => new _PreImgIaState();
}

class _PreImgIaState extends State<PreImgIa> {
  String? base64Image;
  Response? retorno;

  List<Cobject> cobjectList = [];
  int questionIndex = 0;
  int? cobjectIndex;
  int? cobjectIdListLength;
  int? cobjectQuestionsLength;

  double opacityFaleAgora = 0;
  double opacityNaoEntendivel = 0;

  Color colorAlertMessage = Colors.red;
  bool isCorrect = false;

  String? correctAnswer;
  bool firstRecording = true;

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  // final buttonStateProvider = StateProvider<bool>((ref) {
  //   return false;
  // });

  @override
  void initState() {
    super.initState();
    _textController.text = "";
  }

  void submitButton(BuildContext context) {
    // context.read(buttonStateProvider).state = true;
  }

  @override
  Widget build(BuildContext context) {

    cobjectList = [];
    questionIndex = 1;
    cobjectIndex = 1;
    cobjectIdListLength = 1;
    cobjectQuestionsLength = 1;

    String questionDescription = cobjectList[0].description!;
    String questionText =
        cobjectList[0].questions[questionIndex].header["text"]!;
    String? pieceId = cobjectList[0].questions[questionIndex].pieceId;

    correctAnswer = cobjectList[0].questions[0].pieces["1"]["text"];

    double widthScreen = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height * 0.93;


    return Scaffold(
    //   body: TemplateSlider(
    //     headerView: HeaderView(containerModel: ContainerModel.empty()),
    //     // taskViewController: TaskViewController(),
    //     // title: questionDescription.toUpperCase(),
    //     // text: formatDescription(questionText.toUpperCase()),
    //     // // text: Text(
    //     // //   questionText.toUpperCase(),
    //     // //   textAlign: TextAlign.center,
    //     // //   style: TextStyle(
    //     // //     fontWeight: FontWeight.bold,
    //     // //     fontSize: fonteDaLetra,
    //     // //     fontFamily: 'Mulish',
    //     // //   ),
    //     // // ),
    //     // sound: cobjectList[0].questions[questionIndex].header["sound"],
    //     // linkImage: cobjectList[0].questions[0].header["image"]!.isNotEmpty
    //     //     ? 'https://apielesson.azurewebsites.net/app/library/image/' +
    //     //         cobjectList[0].questions[0].header["image"]!
    //     //     : null,
    //     // isPreTemplate: true,
    //     bodyView: Form(
    //       key: _formKey,
    //       child: SingleChildScrollView(
    //         reverse: false,
    //         child: Wrap(
    //           children: <Widget>[
    //             Stack(
    //               children: <Widget>[
    //                 Container(
    //                   margin: EdgeInsets.only(
    //                     right: 16,
    //                     left: 16,
    //                     top: screenHeight * 0.2,
    //                   ),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(12),
    //                     border: Border.all(
    //                       color: Color.fromRGBO(189, 0, 255, 0.2),
    //                       width: 2,
    //                     ),
    //                   ),
    //                   height: screenHeight / 3,
    //                   child: Center(
    //                     child: TextFormField(
    //                       textCapitalization: TextCapitalization.characters,
    //                       autocorrect: false,
    //                       maxLines: 3,
    //                       minLines: 1,
    //                       enableSuggestions: false,
    //                       keyboardType: TextInputType.visiblePassword,
    //                       controller: _textController,
    //                       autofocus: false,
    //                       textAlign: TextAlign.center,
    //                       style: TextStyle(
    //                         color: Color(0xFF0000FF),
    //                         fontSize: 18,
    //                         fontWeight: FontWeight.bold,
    //                         fontFamily: 'Mulish',
    //                       ),
    //                       decoration: InputDecoration(
    //                         filled: true,
    //                         fillColor: Colors.white,
    //                         hintText: 'Digite a resposta aqui',
    //                         contentPadding: const EdgeInsets.all(8.0),
    //                         focusedBorder: OutlineInputBorder(
    //                           borderSide: BorderSide(color: Colors.white),
    //                           borderRadius: BorderRadius.circular(25.7),
    //                         ),
    //                         enabledBorder: UnderlineInputBorder(
    //                           borderSide: BorderSide(color: Colors.white),
    //                           borderRadius: BorderRadius.circular(25.7),
    //                         ),
    //                       ),
    //                       onChanged: (val) {
    //                         verificarResposta(
    //                                 respostasCorretas: correctAnswer!,
    //                                 respostaUsuario:
    //                                     _textController.text.toString())
    //                             // correctAnswer == _textController.text.toString()
    //                             ? isCorrect = true
    //                             : isCorrect = false;
    //
    //                         print(
    //                             "CORRETA: $correctAnswer , DIGITADA: ${_textController.text.toString()} ");
    //                         if (_textController.text.length == 1) {
    //                           submitButton(context);
    //                         }
    //                       },
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Não se esqueça de digitar a resposta!';
    //                         }
    //                         return null;
    //                       },
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   margin: EdgeInsets.only(
    //                       bottom: _textController.text.isNotEmpty
    //                           ? (screenHeight * 0.93) -
    //                               18 -
    //                               (48 > screenHeight * 0.0656
    //                                   ? 48
    //                                   : screenHeight * 0.0656)
    //                           : screenHeight * 0.92),
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: Color.fromRGBO(0, 0, 76, 0.1),
    //                         spreadRadius: 1,
    //                       ),
    //                     ],
    //                   ),
    //                   height: screenHeight * 0.15,
    //                   width: widthScreen,
    //                   child: Center(
    //                     child: GestureDetector(
    //                       onTap: () {
    //                         playSound(cobjectList[0]
    //                             .questions[questionIndex]
    //                             .header["sound"]);
    //                       },
    //                       child: Container(
    //                         padding: EdgeInsets.all(20),
    //                         child:
    //                             formatDescription(questionText.toUpperCase()),
    //                         // child: Text(
    //                         //   questionText.toUpperCase(),
    //                         //   style: TextStyle(
    //                         //     fontWeight: FontWeight.bold,
    //                         //     fontSize: fonteDaLetra,
    //                         //     fontFamily: 'Mulish',
    //                         //   ),
    //                         // ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //                 Container(
    //                   width: widthScreen,
    //                   margin: EdgeInsets.only(top: screenHeight * 0.65),
    //                   child: Center(
    //                     child: Column(
    //                       children: [
    //                         Text(
    //                           "naoEndendivel",
    //                           textAlign: TextAlign.center,
    //                           style: TextStyle(
    //                             fontSize: widthScreen * 0.05,
    //                             fontWeight: FontWeight.bold,
    //                             color: colorAlertMessage
    //                                 .withOpacity(opacityNaoEntendivel),
    //                           ),
    //                         ),
    //                         Text(
    //                           "alertMessage",
    //                           style: TextStyle(
    //                             fontSize: widthScreen * 0.05,
    //                             fontWeight: FontWeight.bold,
    //                             color: Color(0xFF0000FF)
    //                                 .withOpacity(opacityFaleAgora),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //
    //                 // ------------ GRAVAÇÃO DA VOZ ----------------
    //
    //                 GestureDetector(
    //                   onTap: () async {
    //                     await getGoogleApiToken();
    //                     await pickImage();
    //                     await loadingLocalAlertDialog(context);
    //                     if (retorno != null) {
    //                       setState(() {
    //                         _textController.text = retorno!.data["responses"][0]
    //                             ['textAnnotations'][0]['description'];
    //                       });
    //                     }
    //                   },
    //                   child: Container(
    //                     margin: EdgeInsets.only(
    //                       top: screenHeight * 0.80,
    //                       left: widthScreen * 0.45,
    //                     ),
    //                     padding: EdgeInsets.all(6),
    //                     decoration: BoxDecoration(
    //                       border:
    //                           Border.all(color: Color.fromRGBO(0, 0, 255, 1)),
    //                       color: buttonBackground,
    //                       borderRadius: BorderRadius.circular(18.0),
    //                     ),
    //                     child: Icon(
    //                       Icons.camera,
    //                       size: 40,
    //                       color: iconBackground,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             SizedBox(height: 15),
    //             if (_textController.text.isNotEmpty)
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 3.0),
    //                 // child: submitAnswer(context, cobjectList, 'PRE',
    //                 //     ++questionIndex, cobjectIndex, pieceId, isCorrect,
    //                 //     value: _textController.text),
    //                 child: Center(
    //                   child: ConfirmButtonWidget(
    //                     context: context,
    //                     cobjectList: cobjectList,
    //                     cobjectIdList: cobjectIdList,
    //                     questionType: 'PRE',
    //                     questionIndex: ++questionIndex,
    //                     cobjectIndex: cobjectIndex,
    //                     cobjectIdListLength: cobjectIdListLength,
    //                     cobjectQuestionsLength: cobjectQuestionsLength,
    //                     pieceId: pieceId,
    //                     isCorrect: isCorrect,
    //                     value: _textController.text,
    //                   ),
    //                 ),
    //               ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    );
  }

  loadingLocalAlertDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            insetPadding:
                EdgeInsets.all(MediaQuery.of(context).size.width * 0.39),
            content: CircularProgressIndicator(),
          ),
        );
      },
    );
    int retorno = await extractText();
    if (retorno != 0) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      extractErrorAlertDialog(context);
    }
  }

  extractErrorAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );
    AlertDialog alerta = AlertDialog(
      title: Text("Erro"),
      content: Text("Erro ao detectar texto!!"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  //=======================================

  // função para extrair texto da imagem enviando o base64 dela
  Future<int> extractText() async {
    // print(googleApiToken);
    print(base64Image);
    try {
      retorno = await Dio().post(
        "https://vision.googleapis.com/v1/images:annotate",
        options: Options(
            // headers: {'Authorization': googleApiToken},
            contentType: "application/json"),
        data: {
          "requests": [
            {
              "image": {
                "content": base64Image,
              },
              "features": [
                {"type": "DOCUMENT_TEXT_DETECTION"}
              ]
            }
          ]
        },
      );
      return 1;
    } catch (e) {
      print(e);
    }
    return 0;
  }

  // função para tirar foto
  Future<String> pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    imageFile = File(pickedFile!.path);
    return await converter();
  }

  late File imageFile;

  final picker = ImagePicker();

  // função para converter imagem para base64
  Future<String> converter() async {
    List<int> imageBytes = imageFile.readAsBytesSync();
    String convertido = base64Encode(imageBytes);
    return convertido;
  }
}
